import factory
import logging
import string

from factory import fuzzy

from contacts import models


logger = logging.getLogger('factory')
logger.setLevel(logging.ERROR)


class ContactFactory(factory.DjangoModelFactory):
    full_name = factory.Faker('name', locale='ru_RU')
    address = factory.Faker('address', locale='ru_RU')

    class Meta:
        model = models.Contact


class PhoneFactory(factory.DjangoModelFactory):
    value = fuzzy.FuzzyText(
        length=11, chars=string.digits, prefix=''
    )
    contact = factory.SubFactory(ContactFactory)

    class Meta:
        model = models.Phone
