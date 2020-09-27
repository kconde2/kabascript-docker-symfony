# Make coding more python3-ish
from __future__ import (absolute_import, division, print_function, unicode_literals)
__metaclass__ = type

import types
import bcrypt

from ansible import errors
from ansible.module_utils.six import string_types

def double_dollars_password_hash(value):
    ''' Convert dollar to double dollars in a string '''
    hashed = bcrypt.hashpw(password=value.encode('utf-8'), salt=bcrypt.gensalt())
    return hashed.decode('utf-8').replace('$', '$$')

class FilterModule(object):
  ''' KS Docker Symfony jinja2 filters '''

  def filters(self):
    return {
        'docker_composer_password_hash': double_dollars_password_hash
    }
