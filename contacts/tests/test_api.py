import pytest

from django.urls import reverse
from django.utils import timezone as tz

from rest_framework.test import APIClient


from ..models import Phone
from .factories import PhoneFactory


@pytest.mark.django_db
def test_contacts():
    AMOUNT = 20
    phones = PhoneFactory.create_batch(AMOUNT)
    assert len(phones) == AMOUNT

    client = APIClient()
    url = reverse("phonebook")
    response = client.get(url)
    assert response.status_code == 200
    assert len(response.data) == AMOUNT

    now = tz.now()  # UTC now
    date_filtered_url = "?".join(
        [
            url, "created_at__gt={}".format(
                now.strftime("%Y-%m-%dT%H:%M:%S.%fZ")  # TRUE ISO-8601
            )
        ]
    )
    response = client.get(date_filtered_url)
    assert response.status_code == 200
    assert len(response.data) == Phone.objects.filter(created_at__gt=now).count()

    LATEST_AMOUNT = 10
    PhoneFactory.create_batch(LATEST_AMOUNT)
    assert Phone.objects.filter(created_at__gt=now).count() == LATEST_AMOUNT

    response = client.get(date_filtered_url)
    assert response.status_code == 200
    assert len(response.data) == LATEST_AMOUNT
