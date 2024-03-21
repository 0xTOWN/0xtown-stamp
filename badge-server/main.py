from datetime import datetime, timezone
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from jinja2 import Environment, FileSystemLoader


app = FastAPI()
env = Environment(loader=FileSystemLoader("templates"))


@app.get("/{number}")
async def root(number: int, visitor: str, ts: int):
    template = env.get_template("badge.svg")
    rendered_svg = template.render(
        number=number,
        purpose='Early Supporter',
        address1=visitor[:len(visitor)//2],
        address2=visitor[len(visitor)//2:],
        timestamp=datetime.fromtimestamp(
            ts, timezone.utc).strftime('%Y-%m-%d %H:%M:%S %Z'),
    )
    return HTMLResponse(content=rendered_svg, media_type="image/svg+xml")
