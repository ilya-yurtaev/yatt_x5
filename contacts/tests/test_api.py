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

    now = tz.now()
    date_filtered_url = "?".join([url, "created_at__gte={}".format(now)])
    assert 'wtf' in date_filtered_url
    response = client.get(date_filtered_url)
    assert response.status_code == 200
    # wtf
    assert len(response.data) == Phone.objects.filter(created_at__gte=now).count()
