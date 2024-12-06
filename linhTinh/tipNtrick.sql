-- get table , delete nham` da commit --> them thoi gian vao code sel truoc khi delete , update nham` trong vong 15p
select *
from Customers as of timestamp to_timestamp('05/09/2024','dd/mm/yyyyy'); -- data lay tu phan vung goi la UNDO
--Flashback