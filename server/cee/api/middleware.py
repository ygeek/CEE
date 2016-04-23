# -*- coding: utf-8 -*-


"""
Api middleware module
"""
import logging

request_logger = logging.getLogger('django.request')


class LoggingMiddleware(object):
    """
    Provides full logging of requests and responses
    """
    _initial_http_body = None

    def process_request(self, request):
        self._initial_http_body = request.body

    def process_response(self, request, response):
        """
        Adding request and response logging
        """
        request_logger.log(logging.DEBUG,
                           "HEAD: {}\n"
                           "GET: {}\n"
                           "body: {}\n"
                           "response code: {}\n"
                           "response content: {}"
                           .format(request.META,
                                   request.GET,
                                   self._initial_http_body,
                                   response.status_code,
                                   response.content),
                           extra={
                              'tags': {
                               'url': request.build_absolute_uri()
                              }
                           })
        return response
