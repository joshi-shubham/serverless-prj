import xml.etree.ElementTree as ET
xml_string= """<library>
  <book>
    <title>Clean Code</title>
    <author>Robert C. Martin</author>
  </book>
  <book>
    <title>Atomic Habits</title>
    <author>James Clear</author>
  </book>
</library>
"""

tree = ET.fromstring(xml_string)

for book in tree.findall('book'):
    title = book.find('title')
    author = book.find('author')

    print(title.text)
    print(author.text)