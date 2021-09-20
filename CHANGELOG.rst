^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package kaobook
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

0.9.8 (2021/08/23)
----------------
* Fix some issues

0.9.7 (2021/06/02)
------------------
* Move the packages to the root of the repository
* Introduce the 'bar' chapterstyle
* Fix some issues

0.9.6 (2021/03/23)
------------------
* Short margin tocs
* Dynamic section-number-width in the margintoc
* Use kvoptions instead of xkeyval
* Slight modification of the page layout so that margin and wide pages 
  have the same total width

0.9.5 (2020/12/30)
------------------
* Use \DeclareCiteCommand in kaobiblio.sty (fixes #68)
* Support f24paper
* Include scrhack
* Add \FloatBarrier before marginfigures, tables and listings
* Improve style of header and chapter, esp. for scales different from A4
* Fix overfull boxes in header and chapter layouts
* Increase the width of the page number boxes in the toc
* Fix typos in the docs (contributor: Martin Michlmayr)
* Set default chapter styles for front-, main-, and back- matter

0.9.0 (2020/12/02)
------------------
* First official release on GitHub
* Define \hscale and \vscale, and rescale lengths accordingly
* Allow user to choose papersize in the documentclass options

Ancient history
---------------
* Add the sidecite command modified to work with BibTeX
* Add an example on how to use the kao_book template with BibTeX
* Add short way to references equations, chapters and sections
* Contributors: Giuseppe Silano
