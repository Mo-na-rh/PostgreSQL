with books (description) as ( values ( 'Дейт, К. Дж. Введение в системы баз данных : пер. 
с англ. / Крис Дж. Дейт. – 8-е изд. –  М. : Вильямс, 2005. –  1328 с.'),
( 'Грофф, Дж. SQL. Полное руководство : пер. с англ. / Джеймс Р. Грофф, 
Пол Н. Вайнберг, Эндрю Дж. Оппель. – 3-е изд. – М. : Вильямс, 
2015. – 960 c.' ), ( 'Лузанов, П. PostgreSQL для начинающих / П. Лузанов, 
Е. Рогов, И. Лёвшин ; Postgres Professional. – М., 2017. – 146 с.' ) ),
books_2 (description, ts_description) as ( select description, 
to_tsvector(description) from books )

select description from books_2 where description ~  'SQL';
