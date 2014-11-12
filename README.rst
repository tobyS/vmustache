==================================================
vmustache - Mustache template system for VIMScript
==================================================

vmustache is an implementation of the `Mustache template system`__ in VIMScript.

__ http://mustache.github.com/

.. image:: https://travis-ci.org/tobyS/vmustache.svg?branch=master
   :target: https://travis-ci.org/tobyS/vmustache

-----
Usage
-----

There are two essential functions in vmustache meant to be used directly:

::

    vmustache#RenderString(text, data)

This function parses the template given as the string ``text`` and renders it
with the data provided in the hashmap ``data``. The result of the rendering is
returned as a string. The pedant function

::

    vmustache#RenderFile(file, data)

accepts a file name instead of a string template.

Template syntax
===============

Mustache is a very very simple template language, which has only very few
concepts. Basically you can use variables::

    This is a text with a {{insert_fancy_data}}

Variables are marked with ``{{`` and ``}}`` and can be identified by arbitrary
strings. The second concept are blocks::

    {{#some_block}}
        Block content with {{some_variable}}
    {{/some_block}}

Start of the block is indicated by a ``#``, the end tag is marked with a
``/``. A block can be used to make output optional or repeated for a number of
values.

Blocks can also be invered, which is indicated as follows::

    {{^inverted_block}}
        Block rendered without data.
    {{/inverted_block}}

While normal blocks are only rendered, if data is available, inverted blocks
are rendered if there's none.

Providing data
==============

vmustache accepts data in form of a hashmap. The structure of this hashmap must
correspond to the structure of the template. For example, if you have the
following template::

    Hello {{name}}

The provided data map should look like this::

    let l:data = {"name": "Luke Skywalker"}

For blocks, you typically provide a list of values. Take the following
template::

    {{#list}}
      - {{topic}}
    {{/list}}

Providing this with the following data::

    let l:data = {"list": [ {"topic": "Tokenize"}, {"topic": "Parse"},
        \ {"topic": "Render"} ]}

Will return in the following output::

    - Tokenize

    - Parse

    - Render

Instead of a list with child data for the block, you can also provide just a
plain value to make a block optional. For example::

    This text will {{#optional}}optionally{{/optional}} appear.

With the data::

    let l:data = {"optional": 1}

Will produce::

    This text will optionally appear.

While with::

    let l:data = {}

It will result in::

    This text will appear.

Inverted sections
=================

Inverted sections behave the other way around. So, changing the example from
above to

::

    This text will {{^optional}}optionally{{/optional}} appear.

(note the ``^`` instead of the ``/``), and using the data::

    let l:data = {"optional": 1}

will result in

::

    This text will  appear.

while providing no value for ``"optional"``

::

    let l:data = {}

will make the section content be rendered

::

    This text will optionally appear.

----------------
Missing features
----------------

vmustache does not implement some mustache features (yet?). As there are:

- Unescaped variables
- Partials

The first does not make sense at all, since the output of vmustache is not
escaped at all. How should that work without knowing the context. Partials
would be nice. If somebody wants them: Feel free to send a pull request. :)


..
   Local Variables:
   mode: rst
   fill-column: 79
   End: 
   vim: et syn=rst tw=79
