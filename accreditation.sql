-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Июл 19 2023 г., 15:43
-- Версия сервера: 8.0.30
-- Версия PHP: 8.0.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `accreditation`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`%` PROCEDURE `callc_criteria` (IN `id_app` INT, IN `id_sub` INT, IN `id_crit` INT)   BEGIN

delete from report_criteria_mark
where id_application = id_app and
id_subvision =id_sub and 
id_criteria = id_crit;

CREATE TEMPORARY table temp_criteria_sub (id_sub int, mark_class int, id_criteria int, id_mark int, field4 int);
insert into temp_criteria_sub (id_sub , mark_class , id_criteria , id_mark , field4)
SELECT sub.id_subvision, case when m.mark_class is null then 0 else m.mark_class end, rc.id_criteria, m.id_mark,
case when mr.field4 is null then 0 else mr.field4 end
FROM `subvision` sub
left outer join rating_criteria rc on sub.id_subvision=rc.id_subvision
left outer join mark m on rc.id_criteria=m.id_criteria
left outer join mark_rating mr on sub.id_subvision=mr.id_subvision and m.id_mark=mr.id_mark
left outer join applications a on sub.id_application=a.id_application
WHERE sub.id_subvision= id_sub and 
m.id_criteria=id_crit and m.id_mark is not null and (m.date_close is null or (m.date_close is not null and ( m.date_close > IFNULL(a.date_send, CURDATE()) )));

set @all_mark = 0;
set @all_mark_3 = 0;
set  @all_mark_1 =0;
set @otmetka_all =0;

set @all_mark_class_1 = 0;
set @all_mark_3_class_1= 0;
set  @all_mark_1_class_1 =0;
set @otmetka_all_class_1 =0;

set @all_mark_class_2 = 0;
set @all_mark_3_class_2 = 0;
set  @all_mark_1_class_2 =0;
set @otmetka_all_class_2=0;

set @all_mark_class_3 = 0;
set @all_mark_3_class_3 = 0;
set  @all_mark_1_class_3 =0;
set @otmetka_all_class_3=0;

set @all_mark = (select count(*)
from temp_criteria_sub);

set @all_mark_3 = ( select count(*)
from temp_criteria_sub
where field4 =3);

set  @all_mark_1 =( select count(*)
from temp_criteria_sub
where field4 =1);

set @otmetka_all =  (@all_mark_1/(@all_mark-@all_mark_3))*100;

set @all_mark_class_1 = (select  count(*)
from temp_criteria_sub
where mark_class=1);


set @all_mark_3_class_1=(select count(*)
from temp_criteria_sub
where field4 =3 and  mark_class=1);

set @all_mark_1_class_1 =(select  count(*)
from temp_criteria_sub
where field4 =1 and  mark_class=1);

set @otmetka_all_class_1 = (@all_mark_1_class_1/(@all_mark_class_1-@all_mark_3_class_1))*100;

set @all_mark_class_2 = (select  count(*)
from temp_criteria_sub
where mark_class=2);


set @all_mark_3_class_2 = (select count(*)
from temp_criteria_sub
where field4 =3 and  mark_class=2);

set @all_mark_1_class_2 = (select count(*) 
from temp_criteria_sub
where field4 =1 and  mark_class=2);

set @otmetka_all_class_2 = (@all_mark_1_class_2/(@all_mark_class_2-@all_mark_3_class_2))*100;

set @all_mark_class_3 = (select count(*)
from temp_criteria_sub
where mark_class=3);


set @all_mark_3_class_3 =(select  count(*)
from temp_criteria_sub
where field4 =3 and  mark_class=3);

set @all_mark_1_class_3= (select  count(*)
from temp_criteria_sub
where field4 =1 and  mark_class=3);

set @otmetka_all_class_3 = (@all_mark_1_class_3/(@all_mark_class_3-@all_mark_3_class_3))*100;

INSERT INTO report_criteria_mark(id_application, id_subvision, id_criteria, otmetka_all, otmetka_all_count_yes, otmetka_all_count_all, otmetka_all_count_not_need, otmetka_class_1, otmetka_class_1_count_yes, otmetka_class_1_count_all, otmetka_class_1_count_not_need,otmetka_class_2, otmetka_class_2_count_yes, otmetka_class_2_count_all, otmetka_class_2_count_not_need,otmetka_class_3,otmetka_class_3_count_yes, otmetka_class_3_count_all, otmetka_class_3_count_not_need) 
VALUES(id_app, id_sub, id_crit, IFNULL(@otmetka_all,0),
IFNULL(@all_mark_1,0),IFNULL(@all_mark,0),IFNULL(@all_mark_3,0), IFNULL(@otmetka_all_class_1,0), 
IFNULL(@all_mark_1_class_1,0),IFNULL(@all_mark_class_1,0),IFNULL(@all_mark_3_class_1,0),
IFNULL(@otmetka_all_class_2,0), 
IFNULL(@all_mark_1_class_2,0),IFNULL(@all_mark_class_2,0),IFNULL(@all_mark_3_class_2,0),
IFNULL(@otmetka_all_class_3,0),
IFNULL(@all_mark_1_class_3,0),IFNULL(@all_mark_class_3,0),IFNULL(@all_mark_3_class_3,0));

DROP TEMPORARY TABLE temp_criteria_sub;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `cursor_for_application` (IN `id_app` INT)   BEGIN

delete
from report_application_mark
where id_application= id_app;

delete
from report_subvision_mark
where id_application= id_app;

delete
from report_criteria_mark
where id_application= id_app;

CREATE TEMPORARY table temp_criteria (id_sub int, mark_class int, id_criteria int, id_mark int, field4 int);

insert into temp_criteria (id_sub , mark_class , id_criteria , id_mark , field4)
SELECT sub.id_subvision, case when m.mark_class is null then 0 else m.mark_class end, rc.id_criteria, m.id_mark,
case when mr.field4 is null then 0 else mr.field4 end
FROM `subvision` sub
left outer join rating_criteria rc on sub.id_subvision=rc.id_subvision
left outer join mark m on rc.id_criteria=m.id_criteria
left outer join mark_rating mr on sub.id_subvision=mr.id_subvision and m.id_mark=mr.id_mark
left outer join applications a on sub.id_application=a.id_application
WHERE sub.id_application= id_app and m.id_mark is not null and (m.date_close is null or (m.date_close is not null and ( m.date_close > IFNULL(a.date_send, CURDATE()) )));


set @all_mark = (select count(*)
from temp_criteria);

set @all_mark_3 = ( select count(*)
from temp_criteria
where field4 =3);

set  @all_mark_1 =( select count(*)
from temp_criteria
where field4 =1);

set @otmetka_all =  (@all_mark_1/(@all_mark-@all_mark_3))*100;

set @all_mark_class_1 = (select  count(*)
from temp_criteria
where mark_class=1);


set @all_mark_3_class_1=(select count(*)
from temp_criteria
where field4 =3 and  mark_class=1);

set @all_mark_1_class_1 =(select  count(*)
from temp_criteria
where field4 =1 and  mark_class=1);

set @otmetka_all_class_1 = (@all_mark_1_class_1/(@all_mark_class_1-@all_mark_3_class_1))*100;


set @all_mark_class_2 = (select  count(*)
from temp_criteria
where mark_class=2);


set @all_mark_3_class_2 = (select count(*)
from temp_criteria
where field4 =3 and  mark_class=2);

set @all_mark_1_class_2 = (select count(*) 
from temp_criteria
where field4 =1 and  mark_class=2);

set @otmetka_all_class_2 = (@all_mark_1_class_2/(@all_mark_class_2-@all_mark_3_class_2))*100;

set @all_mark_class_3 = (select count(*)
from temp_criteria
where mark_class=3);


set @all_mark_3_class_3 =(select  count(*)
from temp_criteria
where field4 =3 and  mark_class=3);

set @all_mark_1_class_3= (select  count(*)
from temp_criteria
where field4 =1 and  mark_class=3);

set @otmetka_all_class_3 = (@all_mark_1_class_3/(@all_mark_class_3-@all_mark_3_class_3))*100;

INSERT INTO report_application_mark(id_application, otmetka_all, otmetka_all_count_yes, otmetka_all_count_all, otmetka_all_count_not_need, otmetka_class_1, otmetka_class_1_count_yes, otmetka_class_1_count_all, otmetka_class_1_count_not_need,otmetka_class_2, otmetka_class_2_count_yes, otmetka_class_2_count_all, otmetka_class_2_count_not_need,otmetka_class_3,otmetka_class_3_count_yes, otmetka_class_3_count_all, otmetka_class_3_count_not_need) 
VALUES(id_app,  IFNULL(@otmetka_all,0),
IFNULL(@all_mark_1,0),IFNULL(@all_mark,0),IFNULL(@all_mark_3,0), IFNULL(@otmetka_all_class_1,0), 
IFNULL(@all_mark_1_class_1,0),IFNULL(@all_mark_class_1,0),IFNULL(@all_mark_3_class_1,0),
IFNULL(@otmetka_all_class_2,0), 
IFNULL(@all_mark_1_class_2,0),IFNULL(@all_mark_class_2,0),IFNULL(@all_mark_3_class_2,0),
IFNULL(@otmetka_all_class_3,0),
IFNULL(@all_mark_1_class_3,0),IFNULL(@all_mark_class_3,0),IFNULL(@all_mark_3_class_3,0));

DROP TEMPORARY TABLE temp_criteria;

call cursor_for_subvision(id_app);

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `cursor_for_application_acred` (IN `id_app` INT)   BEGIN


CREATE TEMPORARY table temp_criteria (id_sub int, mark_class int, id_criteria int, id_mark int, field7 int, field4 int);

insert into temp_criteria (id_sub , mark_class , id_criteria , id_mark , field7, field4)
SELECT sub.id_subvision, case when m.mark_class is null then 0 else m.mark_class end, rc.id_criteria, m.id_mark,
case when mr.field7 is null then 0 else mr.field7 end,
case when mr.field4 is null then 0 else mr.field4 end
FROM `subvision` sub
left outer join rating_criteria rc on sub.id_subvision=rc.id_subvision
left outer join mark m on rc.id_criteria=m.id_criteria
left outer join mark_rating mr on sub.id_subvision=mr.id_subvision and m.id_mark=mr.id_mark
left outer join applications a on sub.id_application=a.id_application
WHERE sub.id_application= id_app and m.id_mark is not null and (m.date_close is null or (m.date_close is not null and ( m.date_close > a.date_send))) and (m.date_open is null or (m.date_open is not null and (m.date_open <= a.date_send )));

set @all_mark = (select count(*)
from temp_criteria);

set @all_mark_3 = ( select count(*)
from temp_criteria
where field7 =3);

set  @all_mark_1 =( select count(*)
from temp_criteria
where field7 =1);

set @mark_verif = (select count(*)
from temp_criteria
where field7<>field4
);

set @otmetka_verif =  (@mark_verif /(@all_mark-@all_mark_3))*100;

set @otmetka_all =  (@all_mark_1/(@all_mark-@all_mark_3))*100;

set @all_mark_class_1 = (select  count(*)
from temp_criteria
where mark_class=1);


set @all_mark_3_class_1=(select count(*)
from temp_criteria
where field7 =3 and  mark_class=1);

set @all_mark_1_class_1 =(select  count(*)
from temp_criteria
where field7 =1 and  mark_class=1);

set @otmetka_all_class_1 = (@all_mark_1_class_1/(@all_mark_class_1-@all_mark_3_class_1))*100;


set @all_mark_class_2 = (select  count(*)
from temp_criteria
where mark_class=2);


set @all_mark_3_class_2 = (select count(*)
from temp_criteria
where field7 =3 and  mark_class=2);

set @all_mark_1_class_2 = (select count(*) 
from temp_criteria
where field7 =1 and  mark_class=2);

set @otmetka_all_class_2 = (@all_mark_1_class_2/(@all_mark_class_2-@all_mark_3_class_2))*100;

set @all_mark_class_3 = (select count(*)
from temp_criteria
where mark_class=3);


set @all_mark_3_class_3 =(select  count(*)
from temp_criteria
where field7 =3 and  mark_class=3);

set @all_mark_1_class_3= (select  count(*)
from temp_criteria
where field7 =1 and  mark_class=3);

set @otmetka_all_class_3 = (@all_mark_1_class_3/(@all_mark_class_3-@all_mark_3_class_3))*100;

update report_application_mark
set otmetka_accred_all = IFNULL(@otmetka_all,0), 
otmetka_accred_all_count_yes=IFNULL(@all_mark_1,0), 
otmetka_accred_all_count_all=IFNULL(@all_mark,0),
otmetka_accred_all_count_not_need=IFNULL(@all_mark_3,0),
otmetka_accred_class_1=IFNULL(@otmetka_all_class_1,0), 
otmetka_accred_class_1_count_yes=IFNULL(@all_mark_1_class_1,0),otmetka_accred_class_1_count_all=IFNULL(@all_mark_class_1,0), otmetka_accred_class_1_count_not_need=IFNULL(@all_mark_3_class_1,0),
otmetka_accred_class_2=IFNULL(@otmetka_all_class_2,0), 
otmetka_accred_class_2_count_yes= 
IFNULL(@all_mark_1_class_2,0),otmetka_accred_class_2_count_all=IFNULL(@all_mark_class_2,0),
otmetka_accred_class_2_count_not_need=IFNULL(@all_mark_3_class_2,0),
otmetka_accred_class_3=IFNULL(@otmetka_all_class_3,0),

otmetka_accred_class_3_count_yes=IFNULL(@all_mark_1_class_3,0),
otmetka_accred_class_3_count_all= IFNULL(@all_mark_class_3,0),otmetka_accred_class_3_count_not_need=IFNULL(@all_mark_3_class_3,0),
otmetka_verif=IFNULL(@otmetka_verif,0),
otmetka_verif_count_yes= IFNULL(@mark_verif,0),otmetka_verif_count_all= IFNULL(@all_mark,0),otmetka_verif_count_not_need=IFNULL(@all_mark_3,0)
where id_application=id_app;

DROP TEMPORARY TABLE temp_criteria;

call cursor_for_subvision_acred(id_app);

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `cursor_for_criteria` (IN `id_app` INT, IN `id_sub` INT)   BEGIN
DECLARE is_done_criteria integer default 0;
DECLARE id_criteria_temp integer default 0;

DECLARE criteria_cursor CURSOR FOR
SELECT DISTINCT rc.id_criteria
FROM rating_criteria rc
WHERE rc.id_subvision=id_sub;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_done_criteria = 1;
OPEN criteria_cursor;

get_Criteria: LOOP
FETCH criteria_cursor INTO id_criteria_temp;
IF is_done_criteria = 1 THEN 
LEAVE get_Criteria;
END IF;


CREATE TEMPORARY table temp_criteria_sub (id_sub int, mark_class int, id_criteria int, id_mark int, field4 int);


insert into temp_criteria_sub (id_sub , mark_class , id_criteria , id_mark , field4)
SELECT sub.id_subvision, case when m.mark_class is null then 0 else m.mark_class end, rc.id_criteria, m.id_mark,
case when mr.field4 is null then 0 else mr.field4 end
FROM `subvision` sub
left outer join rating_criteria rc on sub.id_subvision=rc.id_subvision
left outer join mark m on rc.id_criteria=m.id_criteria
left outer join mark_rating mr on sub.id_subvision=mr.id_subvision and m.id_mark=mr.id_mark
left outer join applications a on sub.id_application=a.id_application
WHERE sub.id_subvision= id_sub and 
m.id_criteria=id_criteria_temp and m.id_mark is not null and (m.date_close is null or (m.date_close is not null and ( m.date_close > IFNULL(a.date_send, CURDATE()) )));

set @all_mark = 0;
set @all_mark_3 = 0;
set  @all_mark_1 =0;
set @otmetka_all =0;

set @all_mark_class_1 = 0;
set @all_mark_3_class_1= 0;
set  @all_mark_1_class_1 =0;
set @otmetka_all_class_1 =0;

set @all_mark_class_2 = 0;
set @all_mark_3_class_2 = 0;
set  @all_mark_1_class_2 =0;
set @otmetka_all_class_2=0;

set @all_mark_class_3 = 0;
set @all_mark_3_class_3 = 0;
set  @all_mark_1_class_3 =0;
set @otmetka_all_class_3=0;

set @all_mark = (select count(*)
from temp_criteria_sub);

set @all_mark_3 = ( select count(*)
from temp_criteria_sub
where field4 =3);

set  @all_mark_1 =( select count(*)
from temp_criteria_sub
where field4 =1);

set @otmetka_all =  (@all_mark_1/(@all_mark-@all_mark_3))*100;

set @all_mark_class_1 = (select  count(*)
from temp_criteria_sub
where mark_class=1);


set @all_mark_3_class_1=(select count(*)
from temp_criteria_sub
where field4 =3 and  mark_class=1);

set @all_mark_1_class_1 =(select  count(*)
from temp_criteria_sub
where field4 =1 and  mark_class=1);

set @otmetka_all_class_1 = (@all_mark_1_class_1/(@all_mark_class_1-@all_mark_3_class_1))*100;

set @all_mark_class_2 = (select  count(*)
from temp_criteria_sub
where mark_class=2);


set @all_mark_3_class_2 = (select count(*)
from temp_criteria_sub
where field4 =3 and  mark_class=2);

set @all_mark_1_class_2 = (select count(*) 
from temp_criteria_sub
where field4 =1 and  mark_class=2);

set @otmetka_all_class_2 = (@all_mark_1_class_2/(@all_mark_class_2-@all_mark_3_class_2))*100;

set @all_mark_class_3 = (select count(*)
from temp_criteria_sub
where mark_class=3);


set @all_mark_3_class_3 =(select  count(*)
from temp_criteria_sub
where field4 =3 and  mark_class=3);

set @all_mark_1_class_3= (select  count(*)
from temp_criteria_sub
where field4 =1 and  mark_class=3);

set @otmetka_all_class_3 = (@all_mark_1_class_3/(@all_mark_class_3-@all_mark_3_class_3))*100;

INSERT INTO report_criteria_mark(id_application, id_subvision, id_criteria, otmetka_all, otmetka_all_count_yes, otmetka_all_count_all, otmetka_all_count_not_need, otmetka_class_1, otmetka_class_1_count_yes, otmetka_class_1_count_all, otmetka_class_1_count_not_need,otmetka_class_2, otmetka_class_2_count_yes, otmetka_class_2_count_all, otmetka_class_2_count_not_need,otmetka_class_3,otmetka_class_3_count_yes, otmetka_class_3_count_all, otmetka_class_3_count_not_need) 
VALUES(id_app, id_sub, id_criteria_temp, IFNULL(@otmetka_all,0),
IFNULL(@all_mark_1,0),IFNULL(@all_mark,0),IFNULL(@all_mark_3,0), IFNULL(@otmetka_all_class_1,0), 
IFNULL(@all_mark_1_class_1,0),IFNULL(@all_mark_class_1,0),IFNULL(@all_mark_3_class_1,0),
IFNULL(@otmetka_all_class_2,0), 
IFNULL(@all_mark_1_class_2,0),IFNULL(@all_mark_class_2,0),IFNULL(@all_mark_3_class_2,0),
IFNULL(@otmetka_all_class_3,0),
IFNULL(@all_mark_1_class_3,0),IFNULL(@all_mark_class_3,0),IFNULL(@all_mark_3_class_3,0));

DROP TEMPORARY TABLE temp_criteria_sub;

END LOOP get_Criteria;
CLOSE criteria_cursor;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `cursor_for_criteria_acred` (IN `id_app` INT, IN `id_sub` INT)   BEGIN
DECLARE is_done_criteria integer default 0;
DECLARE id_criteria_temp integer default 0;

DECLARE criteria_cursor CURSOR FOR
SELECT DISTINCT rc.id_criteria
FROM rating_criteria rc
WHERE rc.id_subvision=id_sub;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_done_criteria = 1;
OPEN criteria_cursor;

get_Criteria: LOOP
FETCH criteria_cursor INTO id_criteria_temp;
IF is_done_criteria = 1 THEN 
LEAVE get_Criteria;
END IF;


CREATE TEMPORARY table temp_criteria_sub (id_sub int, mark_class int, id_criteria int, id_mark int, field7 int, field4 int);


insert into temp_criteria_sub (id_sub , mark_class , id_criteria , id_mark , field7, field4)
SELECT sub.id_subvision, case when m.mark_class is null then 0 else m.mark_class end, rc.id_criteria, m.id_mark,
case when mr.field7 is null then 0 else mr.field7 end,
case when mr.field4 is null then 0 else mr.field4 end
FROM `subvision` sub
left outer join rating_criteria rc on sub.id_subvision=rc.id_subvision
left outer join mark m on rc.id_criteria=m.id_criteria
left outer join mark_rating mr on sub.id_subvision=mr.id_subvision and m.id_mark=mr.id_mark
left outer join applications a on sub.id_application=a.id_application
WHERE sub.id_subvision= id_sub and 
m.id_criteria=id_criteria_temp and m.id_mark is not null and (m.date_close is null or (m.date_close is not null and ( m.date_close > a.date_send))) and (m.date_open is null or (m.date_open is not null and (m.date_open <= a.date_send )));

set @all_mark = 0;
set @all_mark_3 = 0;
set  @all_mark_1 =0;
set @otmetka_all =0;

set @mark_verif =0;
set @otmetka_verif =0;

set @all_mark_class_1 = 0;
set @all_mark_3_class_1= 0;
set  @all_mark_1_class_1 =0;
set @otmetka_all_class_1 =0;

set @all_mark_class_2 = 0;
set @all_mark_3_class_2 = 0;
set  @all_mark_1_class_2 =0;
set @otmetka_all_class_2=0;

set @all_mark_class_3 = 0;
set @all_mark_3_class_3 = 0;
set  @all_mark_1_class_3 =0;
set @otmetka_all_class_3=0;

set @all_mark = (select count(*)
from temp_criteria_sub);

set @all_mark_3 = ( select count(*)
from temp_criteria_sub
where field7 =3);

set  @all_mark_1 =( select count(*)
from temp_criteria_sub
where field7 =1);

set @otmetka_all =  (@all_mark_1/(@all_mark-@all_mark_3))*100;

set @mark_verif = (select count(*)
from temp_criteria_sub 
where field7<>field4
);

set @otmetka_verif =  (@mark_verif /(@all_mark-@all_mark_3))*100;

set @all_mark_class_1 = (select  count(*)
from temp_criteria_sub
where mark_class=1);


set @all_mark_3_class_1=(select count(*)
from temp_criteria_sub
where field7 =3 and  mark_class=1);

set @all_mark_1_class_1 =(select  count(*)
from temp_criteria_sub
where field7 =1 and  mark_class=1);

set @otmetka_all_class_1 = (@all_mark_1_class_1/(@all_mark_class_1-@all_mark_3_class_1))*100;

set @all_mark_class_2 = (select  count(*)
from temp_criteria_sub
where mark_class=2);


set @all_mark_3_class_2 = (select count(*)
from temp_criteria_sub
where field7 =3 and  mark_class=2);

set @all_mark_1_class_2 = (select count(*) 
from temp_criteria_sub
where field7 =1 and  mark_class=2);

set @otmetka_all_class_2 = (@all_mark_1_class_2/(@all_mark_class_2-@all_mark_3_class_2))*100;

set @all_mark_class_3 = (select count(*)
from temp_criteria_sub
where mark_class=3);


set @all_mark_3_class_3 =(select  count(*)
from temp_criteria_sub
where field7 =3 and  mark_class=3);

set @all_mark_1_class_3= (select  count(*)
from temp_criteria_sub
where field7 =1 and  mark_class=3);

set @otmetka_all_class_3 = (@all_mark_1_class_3/(@all_mark_class_3-@all_mark_3_class_3))*100;

update report_criteria_mark
set otmetka_accred_all = IFNULL(@otmetka_all,0), 
otmetka_accred_all_count_yes=IFNULL(@all_mark_1,0), 
otmetka_accred_all_count_all=IFNULL(@all_mark,0),
otmetka_accred_all_count_not_need=IFNULL(@all_mark_3,0),
otmetka_accred_class_1=IFNULL(@otmetka_all_class_1,0), 
otmetka_accred_class_1_count_yes=IFNULL(@all_mark_1_class_1,0),otmetka_accred_class_1_count_all=IFNULL(@all_mark_class_1,0), otmetka_accred_class_1_count_not_need=IFNULL(@all_mark_3_class_1,0),
otmetka_accred_class_2=IFNULL(@otmetka_all_class_2,0), 
otmetka_accred_class_2_count_yes= 
IFNULL(@all_mark_1_class_2,0),otmetka_accred_class_2_count_all=IFNULL(@all_mark_class_2,0),
otmetka_accred_class_2_count_not_need=IFNULL(@all_mark_3_class_2,0),
otmetka_accred_class_3=IFNULL(@otmetka_all_class_3,0),
otmetka_accred_class_3_count_yes=IFNULL(@all_mark_1_class_3,0),
otmetka_accred_class_3_count_all= IFNULL(@all_mark_class_3,0),otmetka_accred_class_3_count_not_need=IFNULL(@all_mark_3_class_3,0),
otmetka_verif=IFNULL(@otmetka_verif,0),
otmetka_verif_count_yes= IFNULL(@mark_verif,0),otmetka_verif_count_all= IFNULL(@all_mark,0),otmetka_verif_count_not_need=IFNULL(@all_mark_3,0)
where id_application=id_app and id_subvision=id_sub and id_criteria=id_criteria_temp;


DROP TEMPORARY TABLE temp_criteria_sub;

END LOOP get_Criteria;
CLOSE criteria_cursor;

END$$

CREATE DEFINER=`root`@`%` PROCEDURE `cursor_for_subvision` (IN `id_app` INT)   BEGIN

DECLARE is_done integer default 0;
DECLARE id_sub_temp integer default 0;

DECLARE mark_cursor CURSOR FOR
SELECT id_subvision from subvision where id_application=id_app;


DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_done = 1;
OPEN mark_cursor;

get_Sub: LOOP
FETCH mark_cursor INTO id_sub_temp;
IF is_done = 1 THEN 
LEAVE get_Sub;
END IF;


CREATE TEMPORARY table temp_mark_sub (id_sub int, mark_class int, id_criteria int, id_mark int, field4 int);

insert into temp_mark_sub (id_sub , mark_class , id_criteria , id_mark , field4)
SELECT sub.id_subvision, case when m.mark_class is null then 0 else m.mark_class end, rc.id_criteria, m.id_mark,
case when mr.field4 is null then 0 else mr.field4 end
FROM `subvision` sub
left outer join rating_criteria rc on sub.id_subvision=rc.id_subvision
left outer join mark m on rc.id_criteria=m.id_criteria
left outer join mark_rating mr on sub.id_subvision=mr.id_subvision and m.id_mark=mr.id_mark
left outer join applications a on sub.id_application=a.id_application
WHERE sub.id_subvision= id_sub_temp and m.id_mark is not null and (m.date_close is null or (m.date_close is not null and ( m.date_close > IFNULL(a.date_send, CURDATE()) )));


set @all_mark = 0;
set @all_mark_3 = 0;
set  @all_mark_1 =0;
set @otmetka_all =0;

set @all_mark_class_1 = 0;
set @all_mark_3_class_1= 0;
set  @all_mark_1_class_1 =0;
set @otmetka_all_class_1 =0;

set @all_mark_class_2 = 0;
set @all_mark_3_class_2 = 0;
set  @all_mark_1_class_2 =0;
set @otmetka_all_class_2=0;

set @all_mark_class_3 = 0;
set @all_mark_3_class_3 = 0;
set  @all_mark_1_class_3 =0;
set @otmetka_all_class_3=0;

set @all_mark = (select count(*)
from temp_mark_sub);


set @all_mark_3 = ( select count(*)
from temp_mark_sub
where field4 =3);

set  @all_mark_1 =( select count(*)
from temp_mark_sub
where field4 =1);

set @otmetka_all =  (@all_mark_1/(@all_mark-@all_mark_3))*100;





set @all_mark_class_1 = (select  count(*)
from temp_mark_sub
where mark_class=1);


set @all_mark_3_class_1=(select count(*)
from temp_mark_sub
where field4 =3 and  mark_class=1);

set @all_mark_1_class_1 =(select  count(*)
from temp_mark_sub
where field4 =1 and  mark_class=1);

set @otmetka_all_class_1 = (@all_mark_1_class_1/(@all_mark_class_1-@all_mark_3_class_1))*100;


set @all_mark_class_2 = (select  count(*)
from temp_mark_sub
where mark_class=2);


set @all_mark_3_class_2 = (select count(*)
from temp_mark_sub
where field4 =3 and  mark_class=2);

set @all_mark_1_class_2 = (select count(*) 
from temp_mark_sub
where field4 =1 and  mark_class=2);

set @otmetka_all_class_2 = (@all_mark_1_class_2/(@all_mark_class_2-@all_mark_3_class_2))*100;

set @all_mark_class_3 = (select count(*)
from temp_mark_sub
where mark_class=3);


set @all_mark_3_class_3 =(select  count(*)
from temp_mark_sub
where field4 =3 and  mark_class=3);

set @all_mark_1_class_3= (select  count(*)
from temp_mark_sub
where field4 =1 and  mark_class=3);

set @otmetka_all_class_3 = (@all_mark_1_class_3/(@all_mark_class_3-@all_mark_3_class_3))*100;

INSERT INTO report_subvision_mark(id_application, id_subvision, otmetka_all, otmetka_all_count_yes, otmetka_all_count_all, otmetka_all_count_not_need, otmetka_class_1, otmetka_class_1_count_yes, otmetka_class_1_count_all, otmetka_class_1_count_not_need,otmetka_class_2, otmetka_class_2_count_yes, otmetka_class_2_count_all, otmetka_class_2_count_not_need,otmetka_class_3,otmetka_class_3_count_yes, otmetka_class_3_count_all, otmetka_class_3_count_not_need) 
VALUES(id_app, id_sub_temp, IFNULL(@otmetka_all,0),
IFNULL(@all_mark_1,0),IFNULL(@all_mark,0),IFNULL(@all_mark_3,0), IFNULL(@otmetka_all_class_1,0), 
IFNULL(@all_mark_1_class_1,0),IFNULL(@all_mark_class_1,0),IFNULL(@all_mark_3_class_1,0),
IFNULL(@otmetka_all_class_2,0), 
IFNULL(@all_mark_1_class_2,0),IFNULL(@all_mark_class_2,0),IFNULL(@all_mark_3_class_2,0),
IFNULL(@otmetka_all_class_3,0),
IFNULL(@all_mark_1_class_3,0),IFNULL(@all_mark_class_3,0),IFNULL(@all_mark_3_class_3,0));

call cursor_for_criteria(id_app, id_sub_temp);

DROP TEMPORARY TABLE temp_mark_sub;

END LOOP get_Sub;
CLOSE mark_cursor;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `cursor_for_subvision_acred` (IN `id_app` INT)   BEGIN

DECLARE is_done integer default 0;
DECLARE id_sub_temp integer default 0;

DECLARE mark_cursor CURSOR FOR
SELECT id_subvision from subvision where id_application=id_app;


DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_done = 1;
OPEN mark_cursor;

get_Sub: LOOP
FETCH mark_cursor INTO id_sub_temp;
IF is_done = 1 THEN 
LEAVE get_Sub;
END IF;


CREATE TEMPORARY table temp_mark_sub (id_sub int, mark_class int, id_criteria int, id_mark int, field7 int, field4 int);

insert into temp_mark_sub (id_sub , mark_class , id_criteria , id_mark , field7, field4)
SELECT sub.id_subvision, case when m.mark_class is null then 0 else m.mark_class end, rc.id_criteria, m.id_mark,
case when mr.field7 is null then 0 else mr.field7 end,
case when mr.field4 is null then 0 else mr.field4 end
FROM `subvision` sub
left outer join rating_criteria rc on sub.id_subvision=rc.id_subvision
left outer join mark m on rc.id_criteria=m.id_criteria
left outer join mark_rating mr on sub.id_subvision=mr.id_subvision and m.id_mark=mr.id_mark
left outer join applications a on sub.id_application=a.id_application
WHERE sub.id_subvision= id_sub_temp and m.id_mark is not null and (m.date_close is null or (m.date_close is not null and ( m.date_close > a.date_send))) and (m.date_open is null or (m.date_open is not null and (m.date_open <= a.date_send )));


set @all_mark = 0;
set @all_mark_3 = 0;
set  @all_mark_1 =0;
set @otmetka_all =0;

set @mark_verif =0;
set @otmetka_verif =0;

set @all_mark_class_1 = 0;
set @all_mark_3_class_1= 0;
set  @all_mark_1_class_1 =0;
set @otmetka_all_class_1 =0;

set @all_mark_class_2 = 0;
set @all_mark_3_class_2 = 0;
set  @all_mark_1_class_2 =0;
set @otmetka_all_class_2=0;

set @all_mark_class_3 = 0;
set @all_mark_3_class_3 = 0;
set  @all_mark_1_class_3 =0;
set @otmetka_all_class_3=0;

set @all_mark = (select count(*)
from temp_mark_sub);


set @all_mark_3 = ( select count(*)
from temp_mark_sub
where field7 =3);

set  @all_mark_1 =( select count(*)
from temp_mark_sub
where field7 =1);

set @otmetka_all =  (@all_mark_1/(@all_mark-@all_mark_3))*100;


set @mark_verif = (select count(*)
from temp_mark_sub
where field7<>field4
);

set @otmetka_verif =  (@mark_verif /(@all_mark-@all_mark_3))*100;


set @all_mark_class_1 = (select  count(*)
from temp_mark_sub
where mark_class=1);


set @all_mark_3_class_1=(select count(*)
from temp_mark_sub
where field7 =3 and  mark_class=1);

set @all_mark_1_class_1 =(select  count(*)
from temp_mark_sub
where field7 =1 and  mark_class=1);

set @otmetka_all_class_1 = (@all_mark_1_class_1/(@all_mark_class_1-@all_mark_3_class_1))*100;


set @all_mark_class_2 = (select  count(*)
from temp_mark_sub
where mark_class=2);


set @all_mark_3_class_2 = (select count(*)
from temp_mark_sub
where field7 =3 and  mark_class=2);

set @all_mark_1_class_2 = (select count(*) 
from temp_mark_sub
where field7 =1 and  mark_class=2);

set @otmetka_all_class_2 = (@all_mark_1_class_2/(@all_mark_class_2-@all_mark_3_class_2))*100;

set @all_mark_class_3 = (select count(*)
from temp_mark_sub
where mark_class=3);


set @all_mark_3_class_3 =(select  count(*)
from temp_mark_sub
where field7 =3 and  mark_class=3);

set @all_mark_1_class_3= (select  count(*)
from temp_mark_sub
where field7 =1 and  mark_class=3);

set @otmetka_all_class_3 = (@all_mark_1_class_3/(@all_mark_class_3-@all_mark_3_class_3))*100;


update report_subvision_mark
set otmetka_accred_all = IFNULL(@otmetka_all,0), 
otmetka_accred_all_count_yes=IFNULL(@all_mark_1,0), 
otmetka_accred_all_count_all=IFNULL(@all_mark,0),
otmetka_accred_all_count_not_need=IFNULL(@all_mark_3,0),
otmetka_accred_class_1=IFNULL(@otmetka_all_class_1,0), 
otmetka_accred_class_1_count_yes=IFNULL(@all_mark_1_class_1,0),otmetka_accred_class_1_count_all=IFNULL(@all_mark_class_1,0), otmetka_accred_class_1_count_not_need=IFNULL(@all_mark_3_class_1,0),
otmetka_accred_class_2=IFNULL(@otmetka_all_class_2,0), 
otmetka_accred_class_2_count_yes= 
IFNULL(@all_mark_1_class_2,0),otmetka_accred_class_2_count_all=IFNULL(@all_mark_class_2,0),
otmetka_accred_class_2_count_not_need=IFNULL(@all_mark_3_class_2,0),
otmetka_accred_class_3=IFNULL(@otmetka_all_class_3,0),
otmetka_accred_class_3_count_yes=IFNULL(@all_mark_1_class_3,0),
otmetka_accred_class_3_count_all= IFNULL(@all_mark_class_3,0),otmetka_accred_class_3_count_not_need=IFNULL(@all_mark_3_class_3,0),
otmetka_verif=IFNULL(@otmetka_verif,0),
otmetka_verif_count_yes= IFNULL(@mark_verif,0),otmetka_verif_count_all= IFNULL(@all_mark,0),otmetka_verif_count_not_need=IFNULL(@all_mark_3,0)
where id_application=id_app and id_subvision=id_sub_temp;

call cursor_for_criteria_acred(id_app, id_sub_temp);


DROP TEMPORARY TABLE temp_mark_sub;

END LOOP get_Sub;
CLOSE mark_cursor;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `applications`
--

CREATE TABLE `applications` (
  `id_application` int NOT NULL,
  `naim` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sokr_naim` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `unp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ur_adress` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rukovoditel` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `predstavitel` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `soprovod_pismo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `copy_rasp` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `org_structure` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_user` int NOT NULL,
  `id_status` int DEFAULT NULL,
  `date_send` date DEFAULT NULL,
  `date_accept` date DEFAULT NULL,
  `date_complete` date DEFAULT NULL,
  `fileReport` varchar(555) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fileReportSamoocenka` varchar(555) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `applications`
--

INSERT INTO `applications` (`id_application`, `naim`, `sokr_naim`, `unp`, `ur_adress`, `tel`, `email`, `rukovoditel`, `predstavitel`, `soprovod_pismo`, `copy_rasp`, `org_structure`, `id_user`, `id_status`, `date_send`, `date_accept`, `date_complete`, `fileReport`, `fileReportSamoocenka`) VALUES
(42, '36gp', 'Жлобинская ЦРБ', '400080424', 'Республика Беларусь, 247210, Гомельская область, Жлобинский район, г. Жлобин, ул. Воровского, д. 1', '+375 2334 4-25-40', 'zhlcrb@zhlcrb.by', 'Топчий Евгений Николаевич', 'Малиновский Евгений Леонидович', 'Брестский район_26-06-2023_12-16-13.csv', 'download.pdf', 'Справка по работе в РТМС консультирующихся организаций здравоохранения за 2023 год.xlsx', 2, 1, NULL, '2023-07-18', '2023-07-18', 'FORMED (2).xlsx', 'Структура таблиц критериев из приказа.docx');

-- --------------------------------------------------------

--
-- Структура таблицы `cells`
--

CREATE TABLE `cells` (
  `id_cell` int NOT NULL,
  `id_criteria` int NOT NULL,
  `id_column` int NOT NULL,
  `cell` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_application` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `columns`
--

CREATE TABLE `columns` (
  `id_column` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `conditions`
--

CREATE TABLE `conditions` (
  `conditions_id` int NOT NULL,
  `conditions` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `conditions`
--

INSERT INTO `conditions` (`conditions_id`, `conditions`) VALUES
(1, 'Амбулаторная'),
(2, 'Стационарная');

-- --------------------------------------------------------

--
-- Структура таблицы `criteria`
--

CREATE TABLE `criteria` (
  `id_criteria` int NOT NULL,
  `name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type_criteria` int NOT NULL COMMENT '1 - общий 2 - по видам оказания 3 - вспомогательные подразделения',
  `conditions_id` int DEFAULT NULL COMMENT '1-амбулаторно 2 - стационарно'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `criteria`
--

INSERT INTO `criteria` (`id_criteria`, `name`, `type_criteria`, `conditions_id`) VALUES
(3, 'Фельдшерско-акушерский пункт', 1, 1),
(4, 'Врачебная амбулатория общей практики', 1, 1),
(5, 'Городская поликлиника (Районная поликлиника)', 1, 1),
(6, 'Больница сестринского ухода', 1, 2),
(7, 'Участковая больница', 1, 2),
(8, 'Центральная районная больница', 1, 2),
(9, 'Хирургия', 2, 1),
(10, 'Хирургия', 2, 2),
(11, 'Анестезиология и реаниматология', 2, 1),
(12, 'Анестезиология и реаниматология', 2, 2),
(13, 'Акушерство и гинекология', 2, 1),
(14, 'Акушерство и гинекология', 2, 2),
(17, 'Кардиология', 2, 1),
(18, 'Кардиология', 2, 2),
(19, 'Лабораторная диагностика', 3, 1),
(20, 'Лабораторная диагностика', 3, 2),
(21, 'Рентгенодиагностика', 3, 1),
(22, 'Рентгенодиагностика', 3, 2),
(23, 'Компьютерная диагностика', 3, 1),
(24, 'Компьютерная диагностика', 3, 2),
(25, 'Эндокринология', 2, 1),
(26, 'Эндокринология', 2, 2),
(27, 'Гастроэнтерология', 2, 1),
(28, 'Гастроэнтерология', 2, 2),
(29, 'Детская хирургия', 2, 1),
(30, 'Детская хирургия', 2, 2),
(31, 'Неврология', 2, 1),
(32, 'Неврология', 2, 2),
(33, 'Отделение скорой медицинской помощи в структуре ЦРБ', 2, NULL),
(34, 'Пульмонология', 2, 1),
(35, 'Пульмонология', 2, 2),
(36, 'Травматология', 2, 1),
(37, 'Травматология', 2, 2),
(38, 'Центр скорой медицинской помощи', 1, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `mark`
--

CREATE TABLE `mark` (
  `id_mark` int NOT NULL,
  `str_num` int DEFAULT NULL,
  `mark_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `mark_class` int DEFAULT NULL,
  `id_criteria` int DEFAULT NULL,
  `date_close` date DEFAULT NULL,
  `date_open` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `mark`
--

INSERT INTO `mark` (`id_mark`, `str_num`, `mark_name`, `mark_class`, `id_criteria`, `date_close`, `date_open`) VALUES
(83, 1, 'Деятельность структурного подразделения осуществляется в соответствии с Положением о структурном подразделении. Сотрудники структурного подразделения ознакомлены с Положением о структурном подразделении', 3, 25, NULL, NULL),
(84, 2, 'Руководителем структурного подразделения ежеквартально анализируются основные показатели деятельности структурного подразделения, выполнение утвержденных плановых показателей. \r\nРезультаты анализа документируются, предоставляются лицу, ответственному за организацию помощи по эндокринологии.\r\nРезультаты анализа работы структурного подразделения используются для проведения мероприятий по улучшению его деятельности, что подтверждается приказами и распоряжениями по учреждению, решениями медицинского совета', 2, 25, NULL, NULL),
(85, 3, '		Укомплектованность структурного подразделения врачами-эндокринологами не менее 75% по физическим лицам. При наличии в штатном расписании неполных должностей врачей-эндокринологов укомплектованность не менее 96 % по занятым должностям', 1, 25, NULL, NULL),
(86, 4, '	Укомплектованность структурного подразделения медицинскими работниками, имеющими среднее специальное медицинское образование, не менее 75% по физическим лицам. При наличии в штатном расписании неполных должностей среднего медицинского персонала укомплектованность не менее 96 % по занятым должностям ', 1, 25, NULL, NULL),
(87, 5, '		Квалификация медицинских работников структурного подразделения соответствует требованиям законодательных актов и должностной инструкции к занимаемой должности служащего ', 1, 25, NULL, NULL),
(88, 6, '	Наличие квалификационных категорий у врачей-специалистов, специалистов со средним медицинским образованием структурного подразделения 100 % от лиц, подлежащих профессиональной аттестации	', 2, 25, NULL, NULL),
(89, 7, '	Наличие первой, высшей категории у врачей-эндокринологов:\r\nне менее 50% на областном уровне\r\nне менее 80% на республиканском уровне	', 3, 25, NULL, NULL),
(90, 8, '	Медицинские работники структурного подразделения проходят обучение и контроль знаний и навыков по оказанию экстренной и неотложной медицинской помощи с частотой, определяемой руководителем организации, но не реже одного раза в 6 месяцев. \r\nМедицинские работники могут продемонстрировать соответствующие навыки при проведении реанимационных мероприятий', 1, 25, NULL, NULL),
(91, 9, '	Медицинские работники структурного подразделения на регулярной основе (в соответствии с планом) проходят обучение, направленное на поддержание и актуализацию профессиональных знаний и практических навыков. \r\nМедицинские работники структурного подразделения имеют постоянный доступ к базам (справочникам) клинических протоколов диагностики и лечения, других нормативно-правовых актов по организации медицинской помощи ', 3, 25, NULL, NULL),
(92, 10, '	Оснащение структурного подразделения соответствует утвержденному табелю оснащения изделиями медицинского назначения и медицинской техникой ', 2, 25, NULL, NULL),
(93, 11, '	Медицинская техника, находящаяся в эксплуатации в структурном подразделении, обеспечена техническим обслуживанием и ремонтом. Техническое обслуживание и ремонт медицинской техники документируются в структурном подразделении. Заключены договоры на техническое обслуживание', 2, 25, NULL, NULL),
(94, 12, '	В структурном подразделении организовано обучение медицинских работников правилам эксплуатации медицинской техники.  \r\nПроведение обучения документируется', 3, 25, NULL, NULL),
(95, 13, '	Порядок оказания медицинской помощи в структурном подразделении утвержден локальным правовым актом в соответствии с утвержденными порядками оказания медицинской помощи и клиническими протоколами, законодательством Республики Беларусь.\r\nСоблюдается порядок (алгоритмы) оказания срочной и плановой медицинской помощи при эндокринной патологии', 2, 25, NULL, NULL),
(96, 14, '	Работа структурного подразделения обеспечена в сменном режиме', 2, 25, NULL, NULL),
(97, 15, '	Определен порядок оказания медицинской помощи пациентам с эндокринными заболеваниями на период отсутствия в организации здравоохранения врача-специалиста (районный, городской уровень)', 1, 25, NULL, NULL),
(98, 16, '	Соблюдается порядок медицинского наблюдения пациентов с эндокринными заболеваниями в амбулаторных условиях. Руководителем структурного подразделения осуществляется анализ результатов медицинского наблюдения пациентов', 1, 25, NULL, NULL),
(99, 17, '	Обеспечена преемственность с больничными организациями здравоохранения. Определен порядок направления на плановую и экстренную госпитализацию пациентов эндокринологического профиля.  Обеспечено выполнение на амбулаторном этапе рекомендаций по дальнейшему медицинскому наблюдению после выписки', 2, 25, NULL, NULL),
(100, 18, '	Обязательная выдача консультативных заключений консультации пациентов на областном, республиканском уровнях\r\nПередача заключений республиканских, областных врачебных консилиумов в территориальные организации здравоохранения', 2, 25, NULL, NULL),
(101, 19, '	Обеспечена возможность консультаций врачей-специалистов в соответствии с клиническими протоколами диагностики и лечения (в организации здравоохранения или определён порядок направления в другие организации здравоохранения)', 1, 25, NULL, NULL),
(102, 20, '	Оформление медицинской карты амбулаторного больного соответствует установленной форме', 3, 25, NULL, NULL),
(103, 21, '	В структурном подразделении имеются условия для формирования и ведения электронных медицинских документов. Медицинские работники владеют навыками работы в медицинской информационной системе', 2, 25, NULL, NULL),
(104, 22, '	Осуществляется выписка электронных рецептов на лекарственные средства', 2, 25, NULL, NULL),
(105, 23, '	Для врачей-специалистов структурного подразделения обеспечена доступность проведения телемедицинского консультирования, результаты которого документируется \r\nи находится в медицинской карте ', 2, 25, NULL, NULL),
(106, 24, '	Руководителем структурного подразделения проводится оценка качества медицинской помощи в случаях, определенных постановлением Министерства здравоохранения Республики Беларусь от 21 мая 2021 г. № 55 «Об оценке качества медицинской помощи и медицинских экспертиз, экспертизе качества медицинской помощи»	', 3, 25, NULL, NULL),
(107, 25, '	Обеспечено выполнение функции врачебной должности не менее 90%', 2, 25, NULL, NULL),
(108, 26, '	Ежегодное обновление сведений в республиканском регистре «Сахарный диабет» о пациентах с сахарным диабетом, состоящих под медицинским наблюдением в организации здравоохранения с ежеквартальной передачей на областной уровень (районный/ городской уровень)', 3, 25, NULL, NULL),
(109, 27, '	Свод и анализ информации республиканского регистра «Сахарный диабет» с ежеквартальной передачей данных на республиканский уровень (областной уровень)', 3, 25, NULL, NULL),
(110, 28, '	Свод и анализ качества ведения республиканского регистра «Сахарный диабет» (республиканский уровень)', 3, 25, NULL, NULL),
(111, 29, '	Сформирована, укомплектована и доступна укладка «Комы при сахарном диабете» (районный/городской, межрайонный, областной, республиканский уровень)', 1, 25, NULL, NULL),
(112, 30, '	Организован и функционирует кабинет «Диабетическая стопа» (межрайонный, областной уровень)', 1, 25, NULL, NULL),
(113, 31, '	Укомплектованность медицинскими работниками, оснащенность кабинета «Диабетическая стопа» соответствует нормативным документам (межрайонный, областной уровень)	', 3, 25, NULL, NULL),
(114, 32, '	Уровень высоких ампутаций составляет не выше 0,05 (межрайонный, областной уровень)', 3, 25, NULL, NULL),
(115, 33, '	Удельный вес посещений пациентов – жителей районного/городского уровня среди консультативных посещений врачей-эндокринологов областного уровня – не менее 50%', 2, 25, NULL, NULL),
(116, 34, '	Удельный вес посещений пациентов – жителей регионов (кроме г. Минска) среди консультативных посещений врачей-эндокринологов республиканского уровня – не менее 65%', 2, 25, NULL, NULL),
(117, 35, '	Организовано проведение консультаций профессорско-преподавательского состава кафедр эндокринологии, акушерства и гинекологии, хирургии, неврологии и нейрохирургии УО «БГМУ», ГУО «БелМАПО» (республиканский уровень)', 2, 25, NULL, NULL),
(118, 36, '	Организовано проведение Республиканских консилиумов по назначению препаратов соматропина, гонадотропин-рилизинг гормона, аналогов соматостатина, аналогов инсулина у взрослых (республиканский уровень)', 1, 25, NULL, NULL),
(119, 37, '	Организовано взаимодействие с организациями здравоохранения, осуществляющими хирургическое лечение пациентов с заболеваниями эндокринной системы (ГУ «РНПЦ неврологии и нейрохирургии»; Республиканский центр опухолей щитовидной железы, ГУ «РНПЦ онкологии и медицинской радиологии им.Н.Н.Александрова»; ГУ «РНПЦ радиационной медицины и экологии человека») (республиканский уровень)', 2, 25, NULL, NULL),
(120, 38, '	Организован отбор пациентов для проведения радиойодтерапии (республиканский уровень)', 2, 25, NULL, NULL),
(121, 39, '	Удельный вес посещений пациентов с «редкой» эндокринной патологией среди посещений врачей-эндокринологов – не менее 50% (республиканский уровень)', 2, 25, NULL, NULL),
(122, 40, '	Участие работников организации в обучении слушателей циклов повышения квалификации по эндокринологии, ультразвуковой диагностике в эндокринологии, организованных УО «БГМУ», ГУО «БелМАПО» (республиканский уровень)', 3, 25, NULL, NULL),
(123, 41, '	Организация и проведение научно-практических конференций по актуальным вопросам диагностики и лечения заболеваний эндокринной системы (республиканский уровень)', 2, 25, NULL, NULL),
(124, 42, '	Организация и проведение круглых столов, мастер-классов по актуальным вопросам диагностики и лечения заболеваний эндокринной системы (республиканский уровень)', 2, 25, NULL, NULL),
(125, 43, '	Разработка нормативных документов по улучшению организации эндокринологической службы республики (республиканский уровень)', 2, 25, NULL, NULL),
(126, 44, '	Организована возможность проведения исследования гликированного гемоглобина для пациентов с сахарным диабетом в соответствии с клиническими протоколами диагностики и лечения (районный/городской, областной, республиканский уровень)', 1, 25, NULL, NULL),
(127, 45, '	Организована возможность проведения лабораторного исследования тироидных гормонов в соответствии с клиническими протоколами диагностики и лечения (районный/городской, областной, республиканский уровень)', 1, 25, NULL, NULL),
(128, 46, '	Организована возможность проведения лабораторного исследования половых гормонов в соответствии с клиническими протоколами диагностики и лечения (областной, республиканский уровень) ', 1, 25, NULL, NULL),
(129, 47, '	Организована возможность проведения лабораторного исследования редких гормонов в соответствии с клиническими протоколами диагностики и лечения (республиканский уровень)', 1, 25, NULL, NULL),
(130, 48, '	Организована возможность проведения инструментальных исследований в соответствии с клиническими протоколами диагностики и лечения (в организации здравоохранения или определён порядок направления в другие организации здравоохранения) (районный/городской, областной, республиканский уровень)', 1, 25, NULL, NULL),
(131, 49, '	Организовано проведение тонкоигольной пункционной аспирационной биопсии щитовидной железы (областной, республиканский уровень)', 1, 25, NULL, NULL),
(132, 50, '	Организовано проведение постоянного мониторирования гликемии (республиканский уровень)', 3, 25, NULL, NULL),
(133, 51, '	Выписка лекарственных препаратов на льготной/бесплатной основе в соответствии с перечнем основных лекарственных средств, Республиканским формуляром лекарственных средств (районный/городской, областной уровень)', 3, 25, NULL, NULL),
(134, 52, '	Врач-эндокринолог проводит лечение пациентов с эндокринными заболеваниями в соответствии с клиническими протоколами диагностики и лечения (районный/городской, областной, республиканский уровень)	', 1, 25, NULL, NULL),
(135, 53, '	Организован кабинет помповой инсулинотерапии (республиканский уровень)', 3, 25, NULL, NULL),
(136, 54, '	Организовано внедрение современных технологий в ведении пациентов с заболеваниями эндокринной системы (областной, республиканский уровень)', 2, 25, NULL, NULL),
(137, 55, '	Организована работа «Школы сахарного диабета» (районный/городской, областной, республиканский уровень)	', 2, 25, NULL, NULL),
(138, 56, '	Осуществляется формирование заявки на годовую закупку лекарственных средств инсулина (областной, республиканский уровень)', 2, 25, NULL, NULL),
(139, 57, '	Осуществляется контроль обоснованности назначения аналогов инсулина и расходования препаратов инсулина при лекарственном обеспечении пациентов с сахарным диабетом (районный/городской межрайонный, областной, республиканский уровень)', 2, 25, NULL, NULL),
(140, 58, '	Осуществляется обеспечение медицинскими изделиями (тест-полоски, глюкометр, иглы для шприц-ручек) пациентов с сахарным диабетом, состоящих под медицинским наблюдением в организации здравоохранения (районный/городской, областной, республиканский уровень)', 2, 25, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `mark_rating`
--

CREATE TABLE `mark_rating` (
  `id_mark_rating` int NOT NULL,
  `id_mark` int NOT NULL,
  `field4` int DEFAULT NULL COMMENT '1 - да 2 - нет 3 - не требуется',
  `field5` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `field6` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `field7` int DEFAULT NULL COMMENT '1 - да 2 - нет 3 - не требуется',
  `field8` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `id_subvision` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `mark_rating`
--

INSERT INTO `mark_rating` (`id_mark_rating`, `id_mark`, `field4`, `field5`, `field6`, `field7`, `field8`, `id_subvision`) VALUES
(1, 83, 1, '', 'екг', 2, '12', 63),
(2, 84, 2, '', 'qwwwww', 2, '', 63),
(3, 85, 1, '', '', 0, '', 63),
(4, 86, 1, '', '', 1, '', 63),
(5, 87, 0, '', '', 0, '', 63),
(6, 88, 0, '', '', 0, '', 63),
(7, 89, 0, '', '', 0, '', 63),
(8, 90, 0, '', '', 0, '', 63),
(9, 91, 0, '', '', 0, '', 63),
(10, 92, 0, '', '', 0, '', 63),
(11, 93, 0, '', '', 0, '', 63),
(12, 94, 0, '', '', 0, '', 63),
(13, 95, 0, '', '', 0, '', 63),
(14, 96, 0, '', '', 0, '', 63),
(15, 97, 0, '', '', 0, '', 63),
(16, 98, 0, '', '', 0, '', 63),
(17, 99, 0, '', '', 0, '', 63),
(18, 100, 0, '', '', 0, '', 63),
(19, 101, 0, '', '', 0, '', 63),
(20, 102, 0, '', '', 0, '', 63),
(21, 103, 0, '', '', 0, '', 63),
(22, 104, 0, '', '', 0, '', 63),
(23, 105, 0, '', '', 0, '', 63),
(24, 106, 0, '', '', 0, '', 63),
(25, 107, 0, '', '', 0, '', 63),
(26, 108, 0, '', '', 0, '', 63),
(27, 109, 0, '', '', 0, '', 63),
(28, 110, 0, '', '', 0, '', 63),
(29, 111, 0, '', '', 0, '', 63),
(30, 112, 0, '', '', 0, '', 63),
(31, 113, 0, '', '', 0, '', 63),
(32, 114, 0, '', '', 0, '', 63),
(33, 115, 0, '', '', 0, '', 63),
(34, 116, 0, '', '', 0, '', 63),
(35, 117, 0, '', '', 0, '', 63),
(36, 118, 0, '', '', 0, '', 63),
(37, 119, 0, '', '', 0, '', 63),
(38, 120, 0, '', '', 0, '', 63),
(39, 121, 0, '', '', 0, '', 63),
(40, 122, 0, '', '', 0, '', 63),
(41, 123, 0, '', '', 0, '', 63),
(42, 124, 0, '', '', 0, '', 63),
(43, 125, 0, '', '', 0, '', 63),
(44, 126, 0, '', '', 0, '', 63),
(45, 127, 0, '', '', 0, '', 63),
(46, 128, 0, '', '', 0, '', 63),
(47, 129, 0, '', '', 0, '', 63),
(48, 130, 0, '', '', 0, '', 63),
(49, 131, 0, '', '', 0, '', 63),
(50, 132, 0, '', '', 0, '', 63),
(51, 133, 0, '', '', 0, '', 63),
(52, 134, 0, '', '', 0, '', 63),
(53, 135, 0, '', '', 0, '', 63),
(54, 136, 0, '', '', 0, '', 63),
(55, 137, 0, '', '', 0, '', 63),
(56, 138, 0, '', '', 0, '', 63),
(57, 139, 0, '', '', 0, '', 63),
(58, 140, 0, '', '', 0, '', 63),
(59, 83, 2, '', 'sdasd', 0, '', 81),
(60, 84, 1, '', 'azxx', 0, '', 81),
(61, 85, 1, '', '', 0, '', 81),
(62, 86, 0, '', '', 2, '', 81),
(63, 87, 0, '', '', 2, '', 81),
(64, 88, 0, '', '', 0, '', 81),
(65, 89, 0, '', '', 0, '', 81),
(66, 90, 0, '', '', 0, '', 81),
(67, 91, 0, '', '', 0, '', 81),
(68, 92, 0, '', '', 0, '', 81),
(69, 93, 0, '', '', 0, '', 81),
(70, 94, 0, '', '', 0, '', 81),
(71, 95, 0, '', '', 0, '', 81),
(72, 96, 0, '', '', 0, '', 81),
(73, 97, 0, '', '', 0, '', 81),
(74, 98, 0, '', '', 0, '', 81),
(75, 99, 0, '', '', 0, '', 81),
(76, 100, 0, '', '', 0, '', 81),
(77, 101, 0, '', '', 0, '', 81),
(78, 102, 0, '', '', 0, '', 81),
(79, 103, 0, '', '', 0, '', 81),
(80, 104, 0, '', '', 0, '', 81),
(81, 105, 0, '', '', 0, '', 81),
(82, 106, 0, '', '', 0, '', 81),
(83, 107, 0, '', '', 0, '', 81),
(84, 108, 0, '', '', 0, '', 81),
(85, 109, 0, '', '', 0, '', 81),
(86, 110, 0, '', '', 0, '', 81),
(87, 111, 0, '', '', 0, '', 81),
(88, 112, 0, '', '', 0, '', 81),
(89, 113, 0, '', '', 0, '', 81),
(90, 114, 0, '', '', 0, '', 81),
(91, 115, 0, '', '', 0, '', 81),
(92, 116, 0, '', '', 0, '', 81),
(93, 117, 0, '', '', 0, '', 81),
(94, 118, 0, '', '', 0, '', 81),
(95, 119, 0, '', '', 0, '', 81),
(96, 120, 0, '', '', 0, '', 81),
(97, 121, 0, '', '', 0, '', 81),
(98, 122, 0, '', '', 0, '', 81),
(99, 123, 0, '', '', 0, '', 81),
(100, 124, 0, '', '', 0, '', 81),
(101, 125, 0, '', '', 0, '', 81),
(102, 126, 0, '', '', 0, '', 81),
(103, 127, 0, '', '', 0, '', 81),
(104, 128, 0, '', '', 0, '', 81),
(105, 129, 0, '', '', 0, '', 81),
(106, 130, 0, '', '', 0, '', 81),
(107, 131, 0, '', '', 0, '', 81),
(108, 132, 0, '', '', 0, '', 81),
(109, 133, 0, '', '', 0, '', 81),
(110, 134, 0, '', '', 0, '', 81),
(111, 135, 0, '', '', 0, '', 81),
(112, 136, 0, '', '', 0, '', 81),
(113, 137, 0, '', '', 0, '', 81),
(114, 138, 0, '', '', 0, '', 81),
(115, 139, 0, '', '', 0, '', 81),
(116, 140, 0, '', '', 0, '', 81);

-- --------------------------------------------------------

--
-- Структура таблицы `qwer`
--

CREATE TABLE `qwer` (
  `id` int NOT NULL,
  `name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `qwer` int NOT NULL,
  `asdf` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Структура таблицы `rating_criteria`
--

CREATE TABLE `rating_criteria` (
  `id_rating_criteria` int NOT NULL,
  `id_subvision` int NOT NULL,
  `id_criteria` int NOT NULL,
  `value` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `rating_criteria`
--

INSERT INTO `rating_criteria` (`id_rating_criteria`, `id_subvision`, `id_criteria`, `value`) VALUES
(162, 81, 3, 1),
(163, 81, 25, 1),
(164, 63, 25, 1),
(165, 63, 26, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `report_application_mark`
--

CREATE TABLE `report_application_mark` (
  `id_application` int NOT NULL,
  `otmetka_all` int NOT NULL,
  `otmetka_all_count_yes` int DEFAULT NULL,
  `otmetka_all_count_all` int DEFAULT NULL,
  `otmetka_all_count_not_need` int DEFAULT NULL,
  `otmetka_class_1` int NOT NULL,
  `otmetka_class_1_count_yes` int DEFAULT NULL,
  `otmetka_class_1_count_all` int DEFAULT NULL,
  `otmetka_class_1_count_not_need` int DEFAULT NULL,
  `otmetka_class_2` int NOT NULL,
  `otmetka_class_2_count_yes` int DEFAULT NULL,
  `otmetka_class_2_count_all` int DEFAULT NULL,
  `otmetka_class_2_count_not_need` int DEFAULT NULL,
  `otmetka_class_3` int NOT NULL,
  `otmetka_class_3_count_yes` int DEFAULT NULL,
  `otmetka_class_3_count_all` int DEFAULT NULL,
  `otmetka_class_3_count_not_need` int DEFAULT NULL,
  `otmetka_accred_all` int DEFAULT NULL,
  `otmetka_accred_all_count_yes` int DEFAULT NULL,
  `otmetka_accred_all_count_all` int DEFAULT NULL,
  `otmetka_accred_all_count_not_need` int DEFAULT NULL,
  `otmetka_accred_class_1` int DEFAULT NULL,
  `otmetka_accred_class_1_count_yes` int DEFAULT NULL,
  `otmetka_accred_class_1_count_all` int DEFAULT NULL,
  `otmetka_accred_class_1_count_not_need` int DEFAULT NULL,
  `otmetka_accred_class_2` int DEFAULT NULL,
  `otmetka_accred_class_2_count_yes` int DEFAULT NULL,
  `otmetka_accred_class_2_count_all` int DEFAULT NULL,
  `otmetka_accred_class_2_count_not_need` int DEFAULT NULL,
  `otmetka_accred_class_3` int DEFAULT NULL,
  `otmetka_accred_class_3_count_yes` int DEFAULT NULL,
  `otmetka_accred_class_3_count_all` int DEFAULT NULL,
  `otmetka_accred_class_3_count_not_need` int DEFAULT NULL,
  `otmetka_verif` int DEFAULT NULL,
  `otmetka_verif_count_yes` int DEFAULT NULL,
  `otmetka_verif_count_all` int DEFAULT NULL,
  `otmetka_verif_count_not_need` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `report_application_mark`
--

INSERT INTO `report_application_mark` (`id_application`, `otmetka_all`, `otmetka_all_count_yes`, `otmetka_all_count_all`, `otmetka_all_count_not_need`, `otmetka_class_1`, `otmetka_class_1_count_yes`, `otmetka_class_1_count_all`, `otmetka_class_1_count_not_need`, `otmetka_class_2`, `otmetka_class_2_count_yes`, `otmetka_class_2_count_all`, `otmetka_class_2_count_not_need`, `otmetka_class_3`, `otmetka_class_3_count_yes`, `otmetka_class_3_count_all`, `otmetka_class_3_count_not_need`, `otmetka_accred_all`, `otmetka_accred_all_count_yes`, `otmetka_accred_all_count_all`, `otmetka_accred_all_count_not_need`, `otmetka_accred_class_1`, `otmetka_accred_class_1_count_yes`, `otmetka_accred_class_1_count_all`, `otmetka_accred_class_1_count_not_need`, `otmetka_accred_class_2`, `otmetka_accred_class_2_count_yes`, `otmetka_accred_class_2_count_all`, `otmetka_accred_class_2_count_not_need`, `otmetka_accred_class_3`, `otmetka_accred_class_3_count_yes`, `otmetka_accred_class_3_count_all`, `otmetka_accred_class_3_count_not_need`, `otmetka_verif`, `otmetka_verif_count_yes`, `otmetka_verif_count_all`, `otmetka_verif_count_not_need`) VALUES
(35, 26, 5, 20, 1, 14, 1, 8, 1, 50, 4, 8, 0, 0, 0, 4, 0, 15, 3, 20, 0, 38, 3, 8, 0, 0, 0, 8, 0, 0, 0, 4, 0, 45, 9, 20, 0),
(40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(41, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 4, 5, 116, 0, 9, 3, 34, 0, 4, 2, 52, 0, 0, 0, 30, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `report_criteria_mark`
--

CREATE TABLE `report_criteria_mark` (
  `id_application` int NOT NULL,
  `id_subvision` int NOT NULL,
  `id_criteria` int NOT NULL,
  `otmetka_all` int NOT NULL,
  `otmetka_all_count_yes` int DEFAULT NULL,
  `otmetka_all_count_all` int DEFAULT NULL,
  `otmetka_all_count_not_need` int DEFAULT NULL,
  `otmetka_class_1` int NOT NULL,
  `otmetka_class_1_count_yes` int DEFAULT NULL,
  `otmetka_class_1_count_all` int DEFAULT NULL,
  `otmetka_class_1_count_not_need` int DEFAULT NULL,
  `otmetka_class_2` int NOT NULL,
  `otmetka_class_2_count_yes` int DEFAULT NULL,
  `otmetka_class_2_count_all` int DEFAULT NULL,
  `otmetka_class_2_count_not_need` int DEFAULT NULL,
  `otmetka_class_3` int NOT NULL,
  `otmetka_class_3_count_yes` int DEFAULT NULL,
  `otmetka_class_3_count_all` int DEFAULT NULL,
  `otmetka_class_3_count_not_need` int DEFAULT NULL,
  `otmetka_accred_all` int DEFAULT NULL,
  `otmetka_accred_all_count_yes` int DEFAULT NULL,
  `otmetka_accred_all_count_all` int DEFAULT NULL,
  `otmetka_accred_all_count_not_need` int DEFAULT NULL,
  `otmetka_accred_class_1` int DEFAULT NULL,
  `otmetka_accred_class_1_count_yes` int DEFAULT NULL,
  `otmetka_accred_class_1_count_all` int DEFAULT NULL,
  `otmetka_accred_class_1_count_not_need` int DEFAULT NULL,
  `otmetka_accred_class_2` int DEFAULT NULL,
  `otmetka_accred_class_2_count_yes` int DEFAULT NULL,
  `otmetka_accred_class_2_count_all` int DEFAULT NULL,
  `otmetka_accred_class_2_count_not_need` int DEFAULT NULL,
  `otmetka_accred_class_3` int DEFAULT NULL,
  `otmetka_accred_class_3_count_yes` int DEFAULT NULL,
  `otmetka_accred_class_3_count_all` int DEFAULT NULL,
  `otmetka_accred_class_3_count_not_need` int DEFAULT NULL,
  `otmetka_verif` int DEFAULT NULL,
  `otmetka_verif_count_yes` int DEFAULT NULL,
  `otmetka_verif_count_all` int DEFAULT NULL,
  `otmetka_verif_count_not_need` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `report_criteria_mark`
--

INSERT INTO `report_criteria_mark` (`id_application`, `id_subvision`, `id_criteria`, `otmetka_all`, `otmetka_all_count_yes`, `otmetka_all_count_all`, `otmetka_all_count_not_need`, `otmetka_class_1`, `otmetka_class_1_count_yes`, `otmetka_class_1_count_all`, `otmetka_class_1_count_not_need`, `otmetka_class_2`, `otmetka_class_2_count_yes`, `otmetka_class_2_count_all`, `otmetka_class_2_count_not_need`, `otmetka_class_3`, `otmetka_class_3_count_yes`, `otmetka_class_3_count_all`, `otmetka_class_3_count_not_need`, `otmetka_accred_all`, `otmetka_accred_all_count_yes`, `otmetka_accred_all_count_all`, `otmetka_accred_all_count_not_need`, `otmetka_accred_class_1`, `otmetka_accred_class_1_count_yes`, `otmetka_accred_class_1_count_all`, `otmetka_accred_class_1_count_not_need`, `otmetka_accred_class_2`, `otmetka_accred_class_2_count_yes`, `otmetka_accred_class_2_count_all`, `otmetka_accred_class_2_count_not_need`, `otmetka_accred_class_3`, `otmetka_accred_class_3_count_yes`, `otmetka_accred_class_3_count_all`, `otmetka_accred_class_3_count_not_need`, `otmetka_verif`, `otmetka_verif_count_yes`, `otmetka_verif_count_all`, `otmetka_verif_count_not_need`) VALUES
(35, 6, 3, 75, 3, 4, 0, 50, 1, 2, 0, 100, 2, 2, 0, 0, 0, 0, 0, 25, 1, 4, 0, 50, 1, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 100, 4, 4, 0),
(35, 6, 4, 0, 0, 5, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 5, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 5, 0),
(35, 6, 5, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0, 100, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 1, 1, 0),
(35, 6, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(35, 49, 3, 67, 2, 4, 1, 0, 0, 2, 1, 100, 2, 2, 0, 0, 0, 0, 0, 25, 1, 4, 0, 50, 1, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 100, 4, 4, 0),
(35, 49, 4, 0, 0, 5, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 5, 0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 5, 0),
(35, 49, 5, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
(35, 49, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(35, 49, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(40, 58, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 34, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 63, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 81, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 81, 25, 3, 2, 58, 0, 6, 1, 17, 0, 4, 1, 26, 0, 0, 0, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 63, 25, 5, 3, 58, 0, 12, 2, 17, 0, 0, 0, 26, 0, 7, 1, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `report_subvision_mark`
--

CREATE TABLE `report_subvision_mark` (
  `id_application` int NOT NULL,
  `id_subvision` int NOT NULL,
  `otmetka_all` int NOT NULL,
  `otmetka_all_count_yes` int DEFAULT NULL,
  `otmetka_all_count_all` int DEFAULT NULL,
  `otmetka_all_count_not_need` int DEFAULT NULL,
  `otmetka_class_1` int NOT NULL,
  `otmetka_class_1_count_yes` int DEFAULT NULL,
  `otmetka_class_1_count_all` int DEFAULT NULL,
  `otmetka_class_1_count_not_need` int DEFAULT NULL,
  `otmetka_class_2` int NOT NULL,
  `otmetka_class_2_count_yes` int DEFAULT NULL,
  `otmetka_class_2_count_all` int DEFAULT NULL,
  `otmetka_class_2_count_not_need` int DEFAULT NULL,
  `otmetka_class_3` int NOT NULL,
  `otmetka_class_3_count_yes` int DEFAULT NULL,
  `otmetka_class_3_count_all` int DEFAULT NULL,
  `otmetka_class_3_count_not_need` int DEFAULT NULL,
  `otmetka_accred_all` int DEFAULT NULL,
  `otmetka_accred_all_count_yes` int DEFAULT NULL,
  `otmetka_accred_all_count_all` int DEFAULT NULL,
  `otmetka_accred_all_count_not_need` int DEFAULT NULL,
  `otmetka_accred_class_1` int DEFAULT NULL,
  `otmetka_accred_class_1_count_yes` int DEFAULT NULL,
  `otmetka_accred_class_1_count_all` int DEFAULT NULL,
  `otmetka_accred_class_1_count_not_need` int DEFAULT NULL,
  `otmetka_accred_class_2` int DEFAULT NULL,
  `otmetka_accred_class_2_count_yes` int DEFAULT NULL,
  `otmetka_accred_class_2_count_all` int DEFAULT NULL,
  `otmetka_accred_class_2_count_not_need` int DEFAULT NULL,
  `otmetka_accred_class_3` int DEFAULT NULL,
  `otmetka_accred_class_3_count_yes` int DEFAULT NULL,
  `otmetka_accred_class_3_count_all` int DEFAULT NULL,
  `otmetka_accred_class_3_count_not_need` int DEFAULT NULL,
  `otmetka_verif` int DEFAULT NULL,
  `otmetka_verif_count_yes` int DEFAULT NULL,
  `otmetka_verif_count_all` int DEFAULT NULL,
  `otmetka_verif_count_not_need` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `report_subvision_mark`
--

INSERT INTO `report_subvision_mark` (`id_application`, `id_subvision`, `otmetka_all`, `otmetka_all_count_yes`, `otmetka_all_count_all`, `otmetka_all_count_not_need`, `otmetka_class_1`, `otmetka_class_1_count_yes`, `otmetka_class_1_count_all`, `otmetka_class_1_count_not_need`, `otmetka_class_2`, `otmetka_class_2_count_yes`, `otmetka_class_2_count_all`, `otmetka_class_2_count_not_need`, `otmetka_class_3`, `otmetka_class_3_count_yes`, `otmetka_class_3_count_all`, `otmetka_class_3_count_not_need`, `otmetka_accred_all`, `otmetka_accred_all_count_yes`, `otmetka_accred_all_count_all`, `otmetka_accred_all_count_not_need`, `otmetka_accred_class_1`, `otmetka_accred_class_1_count_yes`, `otmetka_accred_class_1_count_all`, `otmetka_accred_class_1_count_not_need`, `otmetka_accred_class_2`, `otmetka_accred_class_2_count_yes`, `otmetka_accred_class_2_count_all`, `otmetka_accred_class_2_count_not_need`, `otmetka_accred_class_3`, `otmetka_accred_class_3_count_yes`, `otmetka_accred_class_3_count_all`, `otmetka_accred_class_3_count_not_need`, `otmetka_verif`, `otmetka_verif_count_yes`, `otmetka_verif_count_all`, `otmetka_verif_count_not_need`) VALUES
(35, 6, 30, 3, 10, 0, 25, 1, 4, 0, 50, 2, 4, 0, 0, 0, 2, 0, 20, 2, 10, 0, 50, 2, 4, 0, 0, 0, 4, 0, 0, 0, 2, 0, 50, 5, 10, 0),
(35, 49, 22, 2, 10, 1, 0, 0, 4, 1, 50, 2, 4, 0, 0, 0, 2, 0, 10, 1, 10, 0, 25, 1, 4, 0, 0, 0, 4, 0, 0, 0, 2, 0, 40, 4, 10, 0),
(40, 58, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(41, 61, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(41, 62, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 86, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 63, 5, 3, 58, 0, 12, 2, 17, 0, 4, 1, 26, 0, 0, 0, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 81, 3, 2, 58, 0, 6, 1, 17, 0, 4, 1, 26, 0, 0, 0, 15, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 83, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `id_role` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`id_role`, `name`) VALUES
(1, 'Администратор'),
(2, 'Аккредитатор'),
(3, 'Пользователь'),
(4, 'Минздрав'),
(5, 'Аккредитация Минск'),
(6, 'Аккредитация Минская область'),
(7, 'Аккредитация Гомель'),
(8, 'Аккредитация Могилев'),
(9, 'Аккредитация Витебск'),
(10, 'Аккредитация Гродно'),
(11, 'Аккредитация Брест');

-- --------------------------------------------------------

--
-- Структура таблицы `status`
--

CREATE TABLE `status` (
  `id_status` int NOT NULL,
  `name_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `status`
--

INSERT INTO `status` (`id_status`, `name_status`) VALUES
(1, 'создано'),
(2, 'новое'),
(3, 'проверяется'),
(4, 'проверено'),
(5, 'отклонено');

-- --------------------------------------------------------

--
-- Структура таблицы `subvision`
--

CREATE TABLE `subvision` (
  `id_subvision` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_application` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `subvision`
--

INSERT INTO `subvision` (`id_subvision`, `name`, `id_application`) VALUES
(63, '36gp', 42),
(81, '123', 42),
(82, '456', 42),
(83, 'поликлиника 35', 42);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id_user` int NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `login` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_role` int NOT NULL,
  `online` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_act` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_time_online` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_page` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `oblast` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id_user`, `username`, `login`, `password`, `id_role`, `online`, `last_act`, `last_time_online`, `last_page`, `oblast`) VALUES
(1, 'Аккредитация', 'accred@mail.ru', '6534cb7340066e972846eaf508de6224', 2, '0', 'q6rd6e9bjh25s8qp5fm5pj2g84dno2ed', '2023-07-19 15:05:14', '/index.php?logout', 0),
(2, '36gp', '36gp@mail.ru', 'ba258829bb23dce283867bb2f8b78d7f', 3, 'q6rd6e9bjh25s8qp5fm5pj2g84dno2ed', 'q6rd6e9bjh25s8qp5fm5pj2g84dno2ed', '2023-07-19 15:39:20', '/index.php?application', 0),
(3, 'admin', 'hancharou@rnpcmt.by', '2c904ec0191ebc337d56194f6f9a08fa', 1, '0', 'b1su7tp9hk5ivlaokbqekarecglgf3uh', '2023-07-13 14:41:03', '/index.php?logout', 0);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`id_application`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_status` (`id_status`);

--
-- Индексы таблицы `cells`
--
ALTER TABLE `cells`
  ADD PRIMARY KEY (`id_cell`),
  ADD KEY `id_application` (`id_application`),
  ADD KEY `id_column` (`id_column`),
  ADD KEY `id_criteria` (`id_criteria`);

--
-- Индексы таблицы `columns`
--
ALTER TABLE `columns`
  ADD PRIMARY KEY (`id_column`);

--
-- Индексы таблицы `conditions`
--
ALTER TABLE `conditions`
  ADD PRIMARY KEY (`conditions_id`);

--
-- Индексы таблицы `criteria`
--
ALTER TABLE `criteria`
  ADD PRIMARY KEY (`id_criteria`),
  ADD KEY `conditions_id` (`conditions_id`);

--
-- Индексы таблицы `mark`
--
ALTER TABLE `mark`
  ADD PRIMARY KEY (`id_mark`),
  ADD KEY `id_criteria` (`id_criteria`);

--
-- Индексы таблицы `mark_rating`
--
ALTER TABLE `mark_rating`
  ADD PRIMARY KEY (`id_mark_rating`),
  ADD KEY `id_mark` (`id_mark`),
  ADD KEY `id_subvision` (`id_subvision`);

--
-- Индексы таблицы `qwer`
--
ALTER TABLE `qwer`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `rating_criteria`
--
ALTER TABLE `rating_criteria`
  ADD PRIMARY KEY (`id_rating_criteria`),
  ADD KEY `id_criteria` (`id_criteria`),
  ADD KEY `id_subvision` (`id_subvision`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_role`);

--
-- Индексы таблицы `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id_status`);

--
-- Индексы таблицы `subvision`
--
ALTER TABLE `subvision`
  ADD PRIMARY KEY (`id_subvision`),
  ADD KEY `id_application` (`id_application`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `id_role` (`id_role`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `applications`
--
ALTER TABLE `applications`
  MODIFY `id_application` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT для таблицы `cells`
--
ALTER TABLE `cells`
  MODIFY `id_cell` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `columns`
--
ALTER TABLE `columns`
  MODIFY `id_column` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `conditions`
--
ALTER TABLE `conditions`
  MODIFY `conditions_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `criteria`
--
ALTER TABLE `criteria`
  MODIFY `id_criteria` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT для таблицы `mark`
--
ALTER TABLE `mark`
  MODIFY `id_mark` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;

--
-- AUTO_INCREMENT для таблицы `mark_rating`
--
ALTER TABLE `mark_rating`
  MODIFY `id_mark_rating` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT для таблицы `rating_criteria`
--
ALTER TABLE `rating_criteria`
  MODIFY `id_rating_criteria` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=175;

--
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `id_role` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT для таблицы `status`
--
ALTER TABLE `status`
  MODIFY `id_status` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `subvision`
--
ALTER TABLE `subvision`
  MODIFY `id_subvision` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=184;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`id_status`) REFERENCES `status` (`id_status`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `cells`
--
ALTER TABLE `cells`
  ADD CONSTRAINT `cells_ibfk_1` FOREIGN KEY (`id_application`) REFERENCES `applications` (`id_application`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `cells_ibfk_2` FOREIGN KEY (`id_column`) REFERENCES `columns` (`id_column`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `cells_ibfk_3` FOREIGN KEY (`id_criteria`) REFERENCES `criteria` (`id_criteria`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `criteria`
--
ALTER TABLE `criteria`
  ADD CONSTRAINT `criteria_ibfk_1` FOREIGN KEY (`conditions_id`) REFERENCES `conditions` (`conditions_id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `mark`
--
ALTER TABLE `mark`
  ADD CONSTRAINT `mark_ibfk_1` FOREIGN KEY (`id_criteria`) REFERENCES `criteria` (`id_criteria`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `mark_rating`
--
ALTER TABLE `mark_rating`
  ADD CONSTRAINT `mark_rating_ibfk_1` FOREIGN KEY (`id_mark`) REFERENCES `mark` (`id_mark`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `mark_rating_ibfk_2` FOREIGN KEY (`id_subvision`) REFERENCES `subvision` (`id_subvision`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `rating_criteria`
--
ALTER TABLE `rating_criteria`
  ADD CONSTRAINT `rating_criteria_ibfk_1` FOREIGN KEY (`id_criteria`) REFERENCES `criteria` (`id_criteria`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `rating_criteria_ibfk_2` FOREIGN KEY (`id_subvision`) REFERENCES `subvision` (`id_subvision`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `subvision`
--
ALTER TABLE `subvision`
  ADD CONSTRAINT `subvision_ibfk_1` FOREIGN KEY (`id_application`) REFERENCES `applications` (`id_application`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`id_role`) REFERENCES `roles` (`id_role`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
