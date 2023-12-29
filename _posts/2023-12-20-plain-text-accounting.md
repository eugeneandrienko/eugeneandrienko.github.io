---
layout: post
title: Plain text accounting
category: it
date: 2023-12-20 01:29
comments: true
hidden:
  - related_posts
summary: Ведение личного бюджета методом «денежных конвертов» при помощи hledger, sed, awk и sqlite.
---

С давних пор, как только устроился на свою первую работу, я вёл бюджет —
чтобы понимать сколько и на что я трачу, сколько по каким статьям
бюджета я могу потратить и так далее. К тому же, просто приятно глядеть
на числа со своими доходами (и, увы, менее приятно — на свои расходы).

## Блокнот и ручка

Изначально средством для ведения бюджета была просто перьевая ручка и
блокнот, куда я записывал планируемые расходы на пару недель (от
зарплаты до аванса и наоборот) и планируемый остаток. Статьи бюджета
определились сами собой, над ними я долго не думал:

- **связь**: интернет и мобильный телефон
- **еда**
- **досуг**: тут всё, от чего я отдыхаю — от кино и ресторанов, до
  покупки термопасты
- **быт**: всякая бытовая химия
- **аренда**: аренда квартиры
- **здоровье**: аптеки, походы по врачам и прочие развлечения для тех,
  кому за 30
- **транспорт**: автобусы, метро и такси
- и так далее.

``` example
|----------------+------------------+-------------------|
| Budget item    | Planned expenses | Planned remainder |
|----------------+------------------+-------------------|
| Communications |              500 |             13000 |
| Food           |            10000 |              3000 |
| Household      |             2000 |              1000 |
| Transport      |             1000 |                 0 |
|----------------+------------------+-------------------|
```

Как нетрудно заметить, я использую методику «конвертов» для планирования
расходов. Только конверты у меня виртуальные — статьи бюджета в таблице.

Достаточно быстро я понял, что мне нужно ещё записывать и числа с
реальными расходами в эту таблицу. В жизни достаточно редко получается
так, что на то же *здоровье* или на *еду* ты тратишь столько же, сколько
и запланировал — а потом сидишь и недоумеваешь по какому «конверту» ты
ушёл в минус.

![](/assets/static/paper_budget.jpg)

Эти расходы я высчитывал вручную в конце каждых двух недель — просто
садился с калькулятором и открытым списком трат в интернет-банке.

## Emacs и Org Mode

Через пару лет мне надоело считать расходы на калькуляторе. К тому же,
хотелось видеть ещё и реальный остаток по статьям бюджета, обновляемый в
реальном времени, а не через каждые две недели. И общий остаток средств
на счёте, рассчитанный исключительно по данным из таблицы — чтобы
контролировать таким образом правильность введённых расходов.

Для этого уже нужен был какой-нибудь табличный процессор, а не блокнот с
ручкой. Поскольку я люблю сидеть в консоли и пользуюсь Emacs — я обратил
своё внимание в сторону [Org Mode](https://orgmode.org/). В нём как раз
можно делать таблицы и работать с ячейками при помощи формул — как
обычных табличных, так и на Emacs Lisp'е.

Почитав документацию я набросал такие таблицы для своего двухнедельного
бюджета:

``` org
#+NAME: incoming
|---+----------------+--------|
|   | Incoming       | Amount |
|---+----------------+--------|
| # | Salary         |   7000 |
| # | Past food      |    900 |
| # | Past household |    289 |
| # | Past transport |    170 |
| # | Past health    |    322 |
|   | All:           |   8681 |
| ^ |                |    all |
|---+----------------+--------|
#+TBLFM: $all=vsum(@2$3..@>>>$3)

#+NAME: budget
|---+---------------+----------+-----------+---------------+----------------|
|   | Expenditure   | Spending | Remainder | Real spending | Real remainder |
|---+---------------+----------+-----------+---------------+----------------|
| # | HCS           |     1000 |      7681 |               |           1000 |
| # | Rent          |     2000 |      5681 |               |           2000 |
| # | Communication |      600 |      5081 |               |            600 |
| # | Food          |     2590 |      2491 |           374 |           2216 |
| # | Household     |      400 |      2091 |           100 |            300 |
| # | Leisure       |     1000 |      1091 |           449 |            551 |
| # | Transport     |      500 |       591 |            80 |            420 |
| # | Health        |      591 |         0 |           100 |            491 |
|---+---------------+----------+-----------+---------------+----------------|
|   |               |          |         0 |      Overall: |           7578 |
| ^ |               |          |         0 |               |        overall |
|---+---------------+----------+-----------+---------------+----------------|
#+TBLFM: $6=$3-$5::@2$4=remote(incoming, $all)-@2$3::@3$4..@>$4=@-1$4-@0$3::$overall=vsum(@II..III$6)
```

Ну и плюс ещё пара таблиц, заполняемых вручную — одна с данными по
накоплениям, а вторая со статистикой расходов по месяцам.

Работало всё это следующим образом. В таблицу с именем `incoming`
вводились данные по доходам и их сумма автоматически попадала в ячейку
`all`. На основании суммы всех доходов рассчитывался планируемый остаток
по бюджетным статьям, а также реальный остаток средств на счёте в ячейке
`overall` из таблицы `budget`.

Какое-то время такая автоматизация меня устраивала. Просто вечером
смотришь расходы в уведомлениях от банка, складываешь числа для нужной
категории и обновляешь соответствующую ячейку с расходами в таблице.

Но тут были и свои неудобства, которые всё так же хотелось бы
автоматизировать. Во-первых, иногда я забывал указать или неправильно
суммировал расходы, из-за чего числа в соответствующей строке таблицы
расходились с реальностью. Из-за того, что данных по каждой транзакции
тут не сохранялось, править такие ошибки было сложно и приходилось
«угадывать», что и где я забыл.

Во-вторых, вести статистику расходов по месяцам было сложно — каждые две
недели надо было вручную складывать суммы и обновлять данные в таблице
со статистикой. Аналогично и для накоплений. К тому же, не было никакого
вменяемого доступа к таблицам за прошлые месяцы — в Org Mode не было
machine-friendly интерфейса для работы с архивированными таблицами.
Разве что написать много-много сложных регулярок, которые будут
разбирать даты и данные.

## Hledger и SQL-скрипты

В этот момент я и задумался о каком-нибудь более простом способе ведения
бюджета. Я уже что-то слышал о [plain-text
accounting'е](https://plaintextaccounting.org/), да и к тому же мне
попалась на глаза статья про [Plain text
бухгалтерию](https://vas3k.club/post/15073/) в Вастрик.Клубе. С первого
раза с ledger'ом не заладилось — руководства и how-to были переусложнены
примерами с кредитными счетами, счетами с акциями, долгами и т.д. и
т.п., чего у меня никогда не водилось. К тому же всё руководства
исходили из того, что вы ведёте свой бюджет непрерывно — постоянно
записываете все расходы, без двухнедельных периодов, как у меня, из-за
чего было не так-то просто перевести мои табличные структуры в сквозной
список трат. И ещё было совершенно неочевидно, как адаптировать систему
«денежных конвертов» для ledger'а.

К счастью, потом я наткнулся на [hledger](https://hledger.org/) и смог
разобраться с принципами, по которым он работает. Всё оказалось
достаточно просто. Как я понял, hledger не является «серебряной пулей»,
которая будет всё автоматически считать за вас. На самом деле это просто
что-то вроде куцей базы данных, которая позволяет SELECT'ить данные по
финансовым транзакциям, фильтруя их по имени счёта или по дате и т.д., с
приятной возможностью конвертировать на лету одни валюты в другие.

Всё остальное накручивается уже поверх этой функциональности.

![](/assets/static/main_ledger_window.png)

### «Денежные конверты» в hledger

Чтобы методика «денежных конвертов» заработала в hledger, мне пришлось
попотеть. К счастью, и до меня были люди, который пользовались ей и
plain-text accounting. Основную идею я взял
[отсюда](https://github.com/simonmichael/hledger/blob/master/examples/budgeting/envelope-budget-auto-1.journal).

Сначала мне пришлось описать все свои расходные счета:

``` ledger
account expenses                ; type: X
account expenses:hcs            ; type: X
account expenses:rent           ; type: X
account expenses:communication  ; type: X
account expenses:food           ; type: X
account expenses:household      ; type: X
account expenses:leisure        ; type: X
account expenses:transport      ; type: X
account expenses:psychotherapy  ; type: X
account expenses:health         ; type: X
```

И основной счёт, с которого списываются деньги: `main account:rub`. На
этом этапе всё работало по мануалу — пишем сколько денег ушло на счёт с
расходами, сколько денег ушло с основного счёта. Попытка добавить
отдельные счёта для статей бюджета — ломала мне всю систему,
`hledger balance` отображал какие-то оторванные от реальности числа в
отчёте.

К счастью, [виртуальные
счета](https://hledger.org/1.32/hledger.html#virtual-postings) спасли
меня. Они, плюс правила, связывающие расходные и виртуальные счета —
помогли избежать как странных чисел в отчёте hledger, так и
необходимости указывать бюджетные счета для каждой транзакции.

``` ledger
account budget:hcs            ; type: X
account budget:rent           ; type: X
account budget:communication  ; type: X
account budget:food           ; type: X
account budget:household      ; type: X
account budget:leisure        ; type: X
account budget:transport      ; type: X
account budget:psychotherapy  ; type: X
account budget:health         ; type: X

= ^expenses:hcs
    (budget:hcs)                *-1
= ^expenses:rent
    (budget:rent)               *-1
= ^expenses:communication
    (budget:communication)      *-1
= ^expenses:food
    (budget:food)               *-1
= ^expenses:household
    (budget:household)          *-1
= ^expenses:leisure
    (budget:leisure)            *-1
= ^expenses:transport
    (budget:transport)          *-1
= ^expenses:psychotherapy
    (budget:psychotherapy)      *-1
= ^expenses:health
    (budget:health)             *-1
```

Дальнейшие трудности были связаны с тем, что каждые две недели у меня
новый бюджет и, соответственно новые конверты. А ещё куча архивных
данных из Org Mode, где 100% сходимости бюджета нет — переводы денег в
накопления не отражались нигде, а высчитывать их было сложно и муторно.
Да даже если и высчитать, то в отчёте hledger'а опять таки отображались
какие-то невероятные числа, не связанные с моими расходами за каждые
пару недель.

От невероятных чисел я избавился при помощи ключей `-b YYYY-MM-DD` и `-e
YYYY-MM-DD`, с которыми hledger смотрел только на данные за пару недель
бюджетной итерации. Чтобы он не сходил с ума по поводу доходов,
накоплений и расходов — в начале каждого бюджетного периода я,
специальным скриптом, добавляю в файл явно указанные суммы накоплений и
планируемые расходы на этот период:

``` ledger
2023-12-14 "" | Balancing
    savings:touching     340.08 RUB
    savings:emergency    793.29 RUB
    savings:investments  0 RUB
    savings:foreign     $1
    savings:foreign      1 EUR
    equity:fix

2023-12-14 "" | Salary
    income:paycheck:job       -6000 RUB
    income:from past          -1489 RUB
    main account:rub

2023-12-14 "" | Budgeting
    (budget:hcs)            500 RUB
    (budget:rent)           2000 RUB
    (budget:food)           2500 RUB
    (budget:communication)  600 RUB
    (budget:household)      1000 RUB
    (budget:leisure)        1000 RUB
    (budget:transport)      500 RUB
    (budget:psychotherapy)  1000 RUB
    (budget:health)         1000 RUB
```

Из-за того, что мы ограничили scope hledger'а парой недель — нужно
указывать суммы по всем накопительным счетам, даже если там ноль. Иначе
hledger не будет выводить пустые счета в своём отчёте.

Кроме того, чтобы в отчёте были данные по всем бюджетным и расходным
счетам, даже если мы ничего не потратили за пару недель — приходится
сразу добавлять транзакции с нулём рублей:

``` ledger
2023-12-14 HCS
    expenses:hcs        0 RUB
    main account:rub    0 RUB

2023-12-14 Rent
    expenses:rent       0 RUB
    main account:rub    0 RUB

2023-12-14 Communication
    expenses:communication    0 RUB
    main account:rub          0 RUB

2023-12-14 Food
    expenses:food       0 RUB
    main account:rub    0 RUB

2023-12-14 Household
    expenses:household    0 RUB
    main account:rub      0 RUB

2023-12-14 Leisure
    expenses:leisure      0 RUB
    main account:rub      0 RUB

2023-12-14 Transport
    expenses:transport    0 RUB
    main account:rub      0 RUB

2023-12-14 Psychotherapy
    expenses:psychotherapy    0 RUB
    main account:rub          0 RUB

2023-12-14 Health
    expenses:health     0 RUB
    main account:rub    0 RUB
```

### Конвертация в рубли

Дальнейшую обработку всех этих финансовых данных сильно усложняет то,
что некоторые из счетов мультивалютные. К счастью, hledger тут может
помочь — он сам переводит суммы из долларов и евро в рубли. Для этого
надо в команде указать параметр `--value=then,RUB`, например:

``` bash
hledger -s --value=then,RUB reg -M -E -O csv 'expenses'
```

К файлу с данными должен быть подключен отдельный файл с курсом валют.
Это простой текстовый файл, который выглядит так:

``` ledger
P 2023-12-12 $ 90.9846 RUB
P 2023-12-12 EUR 98.0769 RUB
P 2023-12-14 $ 89.8926 RUB
P 2023-12-14 EUR 96.9500 RUB
P 2023-12-15 $ 89.6741 RUB
P 2023-12-15 EUR 97.7377 RUB
P 2023-12-16 $ 89.6966 RUB
P 2023-12-16 EUR 98.4186 RUB
```

Естественно, заполнять его вручную не нужно — для этого есть bash, curl
и xsltproc. Курсы валют можно забирать с сайта ЦБ РФ, благо они
предоставляют пригодный к использованию XML[^1]. Например, для получения
курса доллара на дату 2022-12-12 нужно выполнить запрос:
<https://cbr.ru/scripts/XML_dynamic.asp?date_req1=12/12/2023&date_req2=12/12/2023&VAL_NM_RQ=R01235>.
В ответ вернётся вот такой XML:

``` xml
<ValCurs ID="R01235" DateRange1="12.12.2023" DateRange2="12.12.2023" name="Foreign Currency Market Dynamic">
    <Record Date="12.12.2023" Id="R01235">
        <Nominal>1</Nominal>
        <Value>90,9846</Value>
        <VunitRate>90,9846</VunitRate>
    </Record>
</ValCurs>
```

Вытащить из него данные с нужной нам ноды можно при помощи xsltproc и
такого XSLT:

``` xml
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  <xsl:template match="ValCurs">
    <xsl:for-each select="Record">
      <xsl:value-of select="Value"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
```

Всё это объединяется в bash-скрипте:

``` bash
#!/usr/bin/env bash

declare -A CURRENCY_CODES=(["$"]="R01235" ["EUR"]="R01239")
CBR_DATE=$(date '+%d/%m/%Y')
CBR_XSLT=$(mktemp /tmp/cbr.XXXXXX.xslt)

JOURNAL="$HOME/path/to/exchange_rates.journal"
JOURNAL_DATE=$(date '+%Y-%m-%d')

cat << EOF > "$CBR_XSLT"
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  <xsl:template match="ValCurs">
    <xsl:for-each select="Record">
      <xsl:value-of select="Value"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
EOF

for curr in "${!CURRENCY_CODES[@]}"; do
    URL="https://cbr.ru/scripts/XML_dynamic.asp?date_req1=$CBR_DATE&date_req2=$CBR_DATE&VAL_NM_RQ=${CURRENCY_CODES[$curr]}"
    EXCHANGE_RATE=$(curl -s "$URL" | xsltproc "$CBR_XSLT" - | sed 's/,/./g')
    if [ ! -n "$EXCHANGE_RATE" ]; then
        continue
    fi
    echo "P $JOURNAL_DATE $curr $EXCHANGE_RATE RUB" >> "$JOURNAL"
done

rm -f "$CBR_XSLT"
```

Который запускается по cron'у каждый день. В итоге у вас всегда свежие
курсы валют, обновляющиеся каждый день!

### Статистика по расходам за каждый месяц

![](/assets/static/expenses.png)

Теперь самое интересное — расширение возможностей hledger.

Hledger умеет экспортировать свои отчёты в CSV, а SQLite умеет загонять
этот XML в таблицы в in-memory базу данных. Что крайне упрощает
дальнейшую обработку всего этого дела, благо SQL предоставляет побольше
возможностей, чем hledger.

Достаточно быстро я разобрался, что расходы, разбитые по месяцам, можно
получить такой командой:

``` bash
hledger -s --value=then,RUB reg -M -E -O csv 'expenses'
```

Путь к файлу не нужно указывать, если он уже указан в переменной
окружения `LEDGER_FILE`.

Но вывод этой команды (даже если убрать `-O csv`) не сильно пригоден для
чтения человеком:

``` example
"txnidx","date","code","description","account","amount","total"
...
"0","2023-11-01","","","expenses:leisure","432.00 RUB","1437564.28 RUB"
"0","2023-11-01","","","expenses:psychotherapy","998.00 RUB","1454562.28 RUB"
"0","2023-11-01","","","expenses:transport","57.00 RUB","1480019.28 RUB"
"0","2023-12-01","","","expenses:leisure","0","1481009.28 RUB"
"0","2023-12-01","","","expenses:psychotherapy","237.96 RUB","1503697.24 RUB"
"0","2023-12-01","","","expenses:transport","0","1503697.24 RUB"
...
```

Да и для SQLite он тоже не пригоден — кавычки не нужны. А нужных мне для
дальнейших расчётов столбцов всего три — дата, статья расходов и сумма
израсходованных средств. Суффикс `RUB` тоже не нужен — **все** суммы и
так уже в рублях. К счастью, тут на помощь приходит магия AWK:

``` bash
awk 'BEGIN {FS=","; OFS=","}
{
    gsub(/"/, "", $0);
    gsub(" RUB", "", $0);
    print $2, $5, $6;
}'
```

В итоге вывод hledger превращается в:

``` example
date,account,amount
...
2023-11-01,expenses:leisure,432.00
2023-11-01,expenses:psychotherapy,998.00
2023-11-01,expenses:transport,57.00
2023-12-01,expenses:leisure,0
2023-12-01,expenses:psychotherapy,237.96
2023-12-01,expenses:transport,0
...
```

Этот CSV уже можно подавать на вход sqlite3, чтобы дальше обрабатывать
получившуюся таблицу `expenses` при помощи SQL:

``` bash
sqlite3 -header -csv ':memory:' '.import --csv /dev/stdin expenses' "
```

Тут после двойной кавычки идёт SQL, который превращает сырые данные из
таблицы `expenses` в нужную мне таблицу:

1.  Сначала я сортирую таблицу `expenses` по дате и по статьям расходов,
    чтобы записи в таблице **точно** шли в нужном порядке:

    ``` sql
    WITH ordered_expenses AS (
        SELECT * FROM expenses
        ORDER BY date, account),
    ```

    ``` example
    +------------+------------------------+--------+
    |    date    |        account         | amount |
    +------------+------------------------+--------+
    | 2023-11-01 | expenses:leisure       | 432.00 |
    | 2023-11-01 | expenses:psychotherapy | 998.00 |
    | 2023-11-01 | expenses:transport     | 57.00  |
    | 2023-12-01 | expenses:leisure       | 0      |
    | 2023-12-01 | expenses:psychotherapy | 237.96 |
    | 2023-12-01 | expenses:transport     | 0      |
    +------------+------------------------+--------+
    ```

2.  Потом использую оконную функцию, чтобы имена счетов шли по оси X, а
    даты так и оставались на оси Y. Примерно вот так:

    ``` example
    |------------+---------+-----------+-----|
    |       date | leisure | transport | hcs |
    |------------+---------+-----------+-----|
    | 2023-11-01 |         |           |     |
    | 2023-12-01 |         |           |     |
    |------------+---------+-----------+-----|
    ```

    Следующий запрос делает таблицу, которая будет последовательно
    заполняться данными о расходах:

    ``` sql
    expenses4gnuplot AS (
    SELECT date,                                           -- Reversed alphanumeric sorting here:
        lag(amount, 0) OVER expenses_win AS transport,     -- expenses:transport
        lag(amount, 1) OVER expenses_win AS rent,          -- expenses:rent
        lag(amount, 2) OVER expenses_win AS psychotherapy, -- expenses:psychotherapy
        lag(amount, 3) OVER expenses_win AS leisure,       -- expenses:leisure
        lag(amount, 4) OVER expenses_win AS household,     -- expenses:household
        lag(amount, 5) OVER expenses_win AS health,        -- expenses:health
        lag(amount, 6) OVER expenses_win AS hcs,           -- expenses:hcs
        lag(amount, 7) OVER expenses_win AS food,          -- expenses:food
        lag(amount, 8) OVER expenses_win AS communication, -- expenses:communication
        row_number() OVER expenses_win AS rownumber
    FROM ordered_expenses
    WINDOW expenses_win AS(PARTITION BY date)
    ORDER BY date, account, rownumber),
    ```

    Результат получается примерно вот таким:

    ``` example
    +------------+-----------+---------------+---------+-----------+
    |    date    | transport | psychotherapy | leisure | rownumber |
    +------------+-----------+---------------+---------+-----------+
    | 2023-11-01 | 432.00    |               |         | 1         |
    | 2023-11-01 | 998.00    | 432.00        |         | 2         |
    | 2023-11-01 | 57.00     | 998.00        | 432.00  | 3         |
    | 2023-12-01 | 0         |               |         | 1         |
    | 2023-12-01 | 237.96    | 0             |         | 2         |
    | 2023-12-01 | 0         | 237.96        | 0       | 3         |
    +------------+-----------+---------------+---------+-----------+
    ```

3.  Очевидно, что мне нужны только те строки, где `rownumber = 3`. Чтобы
    их выбрать — сохраняю даты и соответствующий максимальный
    `rownumber` в отдельной таблице `last`. Понятно, что список статей
    расходов для каждого месяца должен совпадать — иначе всё сломается.
    Именно для этого я явно указываю расход в 0 рублей для каждой
    расходной статьи каждые две недели.

    Запрос для получения таблицы `last`:

    ``` sql
    last AS (
    SELECT date,
        max(rownumber) AS maxrownumber
    FROM expenses4gnuplot GROUP BY date)
    ```

    ``` example
    +------------+--------------+
    |    date    | maxrownumber |
    +------------+--------------+
    | 2023-11-01 | 3            |
    | 2023-12-01 | 3            |
    +------------+--------------+
    ```

4.  Ну и наконец я могу объединить таблицы `expenses` и `last`. Если у
    sqlite3 поменять опцию `--csv` на `--table`, то получается вот такая
    красивая таблица:

    ``` example
    +------------+---------+---------------+-----------+
    |    Date    | Leisure | Psychotherapy | Transport |
    +------------+---------+---------------+-----------+
    | 2023-11-01 | 432.00  | 998.00        | 57.00     |
    | 2023-12-01 | 0       | 237.96        | 0         |
    +------------+---------+---------------+-----------+
    ```

    При помощи вот такого SQL запроса:

    ``` sql
    SELECT e4g.date AS Date,
        e4g.communication AS Communication,
        e4g.food AS Food,
        e4g.hcs AS HCS,
        e4g.health AS Health,
        e4g.household AS Household,
        e4g.leisure AS Leisure,
        e4g.psychotherapy AS Psychotherapy,
        e4g.rent AS Rent,
        e4g.transport AS Transport
    FROM expenses4gnuplot AS e4g
    JOIN last ON e4g.date = last.date AND e4g.rownumber = last.maxrownumber
    ORDER BY e4g.date;
    ```

### Данные по накоплениям

![](/assets/static/savings.png)

С накоплениями по месяцам всё точно так же, как и с расходами. Только
данные от hledger'а теперь получаем по счетам `savings`.

### Планирование нового бюджета

Планирование бюджета происходит через bash-скрипт с dialog.

<div class="planning"><div>
    <a href="/assets/static/plan1.png" data-lightbox="planning">
        <img data-lazy="/assets/static/plan1.png"/>
    </a>
</div>
<div>
    <a href="/assets/static/plan2.png" data-lightbox="planning">
        <img data-lazy="/assets/static/plan2.png"/>
    </a>
</div>
<div>
    <a href="/assets/static/plan3.png" data-lightbox="planning">
        <img data-lazy="/assets/static/plan3.png"/>
    </a>
</div>
<div>
    <a href="/assets/static/plan4.png" data-lightbox="planning">
        <img data-lazy="/assets/static/plan4.png"/>
    </a>
</div>
<div>
    <a href="/assets/static/plan5.png" data-lightbox="planning">
        <img data-lazy="/assets/static/plan5.png"/>
    </a>
</div>
</div><script type="text/javascript">
    $(document).ready(function(){
        $('.planning').slick({
            infinite: false,
            lazyLoad: 'ondemand',
            dots: true
        });
    });
</script>

Тут всё относительно просто:

- Получаю нужные данные от пользователя через формы dialog — даты, суммы
  накоплений, план расходов для бюджета.

- Чтобы не вводить много данных, вытаскиваю из базы накопления для
  предыдущей бюджетной записи и подставляю их в форму:

  ``` bash
  SAVINGS_DATA=$(hledger -s --value=then,RUB reg -E -O csv 'savings' |
      grep -v 'savings:foreign' |
      awk 'BEGIN {FS=","; OFS=","}
      {
          gsub(/"/, "", $0);
          gsub(" RUB", "", $0);
          print $2, $5, $6;
      }' |
      sqlite3 -csv ':memory:' '.import --csv /dev/stdin savings' "
      WITH ordered_savings AS (
          SELECT date, account, amount FROM savings
          WHERE date = (SELECT max(date) FROM savings)
          ORDER BY date, account),
      savings4gnuplot AS (
          SELECT date,                                        -- Reversed alphanumeric sorting here:
              lag(amount, 0) OVER savings_win AS touching,    -- savings:touching
              lag(amount, 1) OVER savings_win AS investments, -- savings:investments
              lag(amount, 2) OVER savings_win AS emergency,   -- savings:emergency
              row_number() OVER savings_win AS rownumber
          FROM ordered_savings
          WINDOW savings_win AS(PARTITION BY date)
          ORDER BY date, account, rownumber),
      last AS (
          SELECT date,
              max(rownumber) AS maxrownumber
          FROM savings4gnuplot GROUP BY date)
      SELECT s4g.touching||' '||s4g.emergency||' '||s4g.investments
      FROM savings4gnuplot AS s4g
      JOIN last ON s4g.date = last.date AND s4g.rownumber = last.maxrownumber
      ORDER BY s4g.date;" |
      sed 's/\"//g')

  OLDIFS="$IFS"
  read -ra SAVINGS_ARRAY <<< "$SAVINGS_DATA"
  IFS="$OLDIFS"

  SAVINGS=(${SAVINGS_ARRAY[0]} ${SAVINGS_ARRAY[1]} ${SAVINGS_ARRAY[2]} 0 0)
  BUDGET_SAVINGS=($($DIALOG --form "Savings information:" 11 43 5 \
      "Touching fund (RUB)" 1 1 "${SAVINGS[0]}" 1 22 15 10 \
      "Emergency fund (RUB)" 2 1 "${SAVINGS[1]}" 2 22 15 10 \
      "Investments (RUB)" 3 1 "${SAVINGS[2]}" 3 22 15 10 \
      "USD" 4 1 "${SAVINGS[3]}" 4 22 15 10 \
      "EUR" 5 1 "${SAVINGS[4]}" 5 22 15 10 \
      2>&1 1>&3))
  ```

- Результаты просто перенаправляю в виде, пригодном для ledger'а, в файл
  `$LEDGER_FILE`.

------------------------------------------------------------------------

[^1]: С техническим описанием можно ознакомиться тут:
    <https://cbr.ru/development/SXML/>
