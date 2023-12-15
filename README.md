# Проект по курсу базы данных

## Логическая схема
![project_db_schema](https://github.com/robibistspark/hse-courses-db-project/assets/71763293/82178cec-1796-4c20-9cad-d2ac272fd155)

Замечание по поводу логической схемы: даты рождения можно хранить в отедельной таблице и через две соответствующих таблицы джойнить эти даты к актёрам и режиссёрам. Но всё-таки (хотя зависит от масштаба базы) считаем, что людей с идеднтичными днями рождения в базе немного.

Ещё, вероятно, было бы неплохо с точки зрения памяти создать табличку Страна - Айди страны и в табличке Country хранить только айдишники (приближаться к атомизму).
