provider "google" {
  project = "tensile-pier-345417"
}

# Enabling Cloud Run API
resource "google_project_service" "run_api" {
  service             = "run.googleapis.com"
  disable_on_destroy  = false
}

# Enabling Cloud Build API
resource "google_project_service" "cloudbuild_api" {
  service = "cloudbuild.googleapis.com"

  disable_on_destroy = false
}

# Setting up environment names
variable "environments" {
  description = "Environments"
  type        = list(string)
  default     = ["staging", "production"]
}


# Creating Cloud Run instances
resource "google_cloud_run_service" "hello" {
  for_each = toset(var.environments)
  name     = "hello-${each.value}"
  location = "europe-west1"

  template {
    spec {
      containers {
        image = "gcr.io/tensile-pier-345417/github.com/alexandroqc/hi-sas:${each.value}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.run_api]
}


# Allow unauthenticated users to connect
data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}


resource "google_cloud_run_service_iam_policy" "noauth" {
  for_each    = toset(var.environments)
  location    = google_cloud_run_service.hello[each.key].location
  project     = google_cloud_run_service.hello[each.key].project
  service     = google_cloud_run_service.hello[each.key].name
  policy_data = data.google_iam_policy.noauth.policy_data
}


resource "google_cloudbuild_trigger" "build-trigger" {
  filename 	= "cloudbuild.yaml"
  name		  = "build-sas"

  github {
    owner   = "alexandroqc"
    name    = "hi-sas"
    push {
      branch = "^main$"
    }
  }
}
