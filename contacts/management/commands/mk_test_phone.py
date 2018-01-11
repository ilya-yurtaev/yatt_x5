from django.core.management.base import BaseCommand

from contacts.tests.factories import PhoneFactory


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('quantity', nargs='?', type=int, default=1)

    def handle(self, *args, **kwargs):
        n = kwargs.get('quantity')

        PhoneFactory.create_batch(n)

        print('number of phones created: {}'.format(n))
