REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [],
    'TEST_REQUEST_DEFAULT_FORMAT': "json",
    'DEFAULT_FILTER_BACKENDS': [
        'django_filters.rest_framework.DjangoFilterBackend',
    ],
}
