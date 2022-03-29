from typing import Optional
from fastapi import FastAPI, Header

app = FastAPI()


@app.get("/")
async def read_root(user_agent: Optional[str] = Header(None)):
    """
    Root path which returns a welcome message and a User Agent.

    :param user_agent: Custom optonal header, if value is not
        given value is taken from request by default
    :returns: Json
    """
    return {"message": "Welcome to 2022", "User-Agent": user_agent}
