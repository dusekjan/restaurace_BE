from http import HTTPStatus
from typing import Optional, Union


class CustomStatus(object):
    def __init__(self, status, phrase):
        self._value = status
        self._phrase = phrase

    @property
    def value(self):
        return self._value

    @property
    def phrase(self):
        return self._phrase


STATUSES = {
    "ok": HTTPStatus.OK,
    "created": HTTPStatus.CREATED,
    "bad_request": HTTPStatus.BAD_REQUEST,
    "unauthorized": HTTPStatus.UNAUTHORIZED,
    "conflict": HTTPStatus.CONFLICT,
    "forbidden": HTTPStatus.FORBIDDEN,
    # custom
    "closed": CustomStatus(432, "Restaurant is closed."),
    "google": CustomStatus(433, "Google account.")
}


def json_response(request_status: str, data: Optional[Union[dict, list]] = None,
                  message: Optional[str] = None, json_status: Optional[int] = None) -> tuple:
    """
    Response JSON object always in ({"message": X, "json_status": Y}, status) format.
    Optionally is possible append key "data".
    """
    status = STATUSES[request_status]
    result = {"message": message if message else status.phrase, "json_status": json_status or status.value}
    if data is not None:
        result.update(data=data)
        print(data, flush=True)

    return result, status.value
