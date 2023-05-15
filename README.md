# Backend Code Exercise

## 📖 TL;DR

### 🧰 Prerequisites

- [Phoenix](https://hexdocs.pm/phoenix/1.5.9/installation.html#content) >= `1.5.9`
- [Elixir](https://elixir-lang.org/) >= `1.7`
- [Postgres](https://www.postgresql.org/about/) >= `11.9`

Following the installation guide for Phoenix will get you in the right track. Be aware of the Erlang and Elixir pairing by following the [compatibility guide](https://hexdocs.pm/elixir/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp).

The application can be opened or ran through the following:

1. [Visual Studio Code](https://code.visualstudio.com/download) with [Remote Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. [`asdf`](https://asdf-vm.com/guide/getting-started.html) - Check the [`.tool-versions`](.tool-versions) for the exact versions.
3. Natively. Manually install based on the prerequisites.

>❓Curious on how I set-up my [development environment](#-development-set-up)?

### 📜 Installation

```console
git clone https://github.com/mjesteban/mario-subscribers.git \
    && cd be-code-exercise--mjesteban \
    && mix deps.get \
    && mix ecto.setup \
    && mix test \
    && mix phx.server
```

Copy the highlighted `Bearer Token` that may look like this:

**`SFMyNTY.g2gDbQAAAAlzb21lIGRhdGFuBgBSoLURiAFiAAFRgA.WAjk8MkiUkPjYNowgIBZOjQMe-vPR_jNvi-0TiUb8No`**

or do a **`mix token`** to generate a new one.

### 🛠️ Usage

The API has a [Postman](https://www.postman.com/downloads/) published [documentation](https://documenter.getpostman.com/view/14741911/2s93ecwAWT) or import the [`postman_collections.json`](priv/data/postman_collection.json) instead.

To the [`curl`](https://curl.se/)ers out there, you may tap into the api through:

```console
curl http://localhost:4000/api/currencies -H "Authorization: Bearer SFMyNTY.g2gDbQAAAAlzb21lIGRhdGFuBgBSoLURiAFiAAFRgA.WAjk8MkiUkPjYNowgIBZOjQMe-vPR_jNvi-0TiUb8No"
```

The API is a REST API. The list of endpoints/routes, as per `mix phx.routes`

#### 🪙 Currency

```console
GET     /api/currencies
GET     /api/currencies/:id
POST    /api/currencies
PATCH   /api/currencies/:id
 PUT    /api/currencies/:id
DELETE  /api/currencies/:id
```
#### 🗺️ Country
```console
GET     /api/countries
GET     /api/countries/:id
POST    /api/countries
PATCH   /api/countries/:id
 PUT    /api/countries/:id
DELETE  /api/countries/:id
```
#### 👨‍🏭 Employee
```console
GET     /api/employees
GET     /api/employees/:id
POST    /api/employees
PATCH   /api/employees/:id
 PUT    /api/employees/:id
DELETE  /api/employees/:id
```
#### 💵 Salary (metrics)
The `:filter` is either a country code, country name, or job title
```console
GET     /api/salaries/:filter
```
---

## 📖 Table of Contents

- 🧰 [Prerequisites](#-prerequisites)
- 📜 [Installation](#-installation)
- 🛠️ [Usage](#-usage)
    - 🪙 [Currency](#-currency)
    - 🗺️ [Country](#-country)
    - 👨‍🏭 [Employee](#-employee)
    - 💵 [Salary (metrics)](#-salary-metrics)
- 📝 [README as Developer's Diary](#-readme-as-developers-diary)
- 👋 [About Me](#-about-me)
- 🗻 [The Challenge](#-the-challenge)
- 🏋️ [Preparation](#-preparation)
- 🖥️ [Development Set Up](#-development-set-up)
    - 🤦 [Configuring a Custom Dev Container](#-configuring-a-custom-dev-container)
    - 🚀 [Into VSCode](#-into-vscode)
    - ⌨️ [`asdf`](#-asdf)
    - ⚙️ [Applications & Browser Tabs](#-applications--browser-tabs)
- 🌈 [The Solution](#-the-solution)
    - 1. 🔧 [Fix existing bugs in the application](#1--fix-existing-bugs-in-the-application)
    - 2. 📑 [Create an employee resource and implement default CRUD operations](#2--create-an-employee-resource-and-implement-default-crud-operations)
            - 🌳 [Employee Context vs Countries Context](#-employee-context-vs-countries-context)
            - 💱 [Currency Field](#-currency-field)
            - 🌱 [Seeding](#-seeding)
            - 💲[Salaries in 🇺🇸 USD](#salaries-in--usd)
    - 3. 🧮 [Implement an endpoint to provide salary metrics about employees](#3--implement-an-endpoint-to-provide-salary-metrics-about-employees)
- 💾 [Data Modeling & Relationships](#-data-modeing--relationships)
    - 🗄️ [Database Tables](#-database-tables)
    - 🧑‍🤝‍🧑 [Entity-Relationship Diagram](#-entity-relationship-diagram)
    - ✔️ [Validation Rules](#-validation-rules)
- 🛣️ [The Extra Mile](#-the-extra-mile)
    - ✂️ [Trim Request *(disabled, tests fail)* 😢](#-trim-request-disabled-tests-fail-)
    - 🔑 [Token Bearer Authentication](#-token-bearer-authentication)
- ℹ️ [Implementation Details](#-implementation-details)
- 🏫 [Other Learning Resources](#-other-learning-resources)
- 🎤 [Feedback](#-feedback)
- 🤯 [Insights](#-insights)
    - 🕹️ [From OO to Functional Programming](#-from-oo-to-functional-programming)
    - ⚗️ [Elixir Features](#-elixir-features)
        - 👙 [Pattern Matching](#-pattern-matching)
        - 🏛️ [Function Clauses](#-function-clauses)
        - 🪃 [~~Return Statement~~](#-return-statement)
        - 🪠 [`|>`iping](#-iping)
        - 🧱 [Rich Data Structures](#-rich-data-structures)
        - 📄+🧪 [DocTest](#-doctest)
    - ✍️ [If I were to Restart...](#-if-i-were-to-restart)
- 💓 [Acknowledgement](#-acknowlegement)

---

## 📝 README as Developer's Diary

To document my developer journey and *and walk you throughout the process* of the exercise, I've used this `README.md` as my developer's diary. It includes notes on pending tasks, prioritized tasks, insights into my analysis paralysis moments, and explanations behind the decisions I've made. This led to the README becoming quite lengthy. To address this, I've also created a [TL;DR](https://en.wikipedia.org/wiki/Wikipedia:Too_long;_didn%27t_read) version that jumps straight into the installation and usage instructions.

## 👋 About Me

*Mabuhay!* I am [Mario](https://www.linkedin.com/in/mario-joseph-esteban/), from the 🇵🇭 Philippines. For the past six years, I worked remotely as a 🐘PHP web developer with slight knowledge on frontend technologies but highly prefers the backend aspect sharpening my analytical and problem solving skills.

I am ready to take my career to the next level 💹 by joining an organized cross-functional development team as well as get into a 🔙 backend technological shift where the tools, such as Elixir/Phoenix, are more robust and scalable compared to PHP, so when I saw that Remote offers that opportunity, I knew I had to 🥅 apply.

## 🗻 The Challenge

> *This exercise requires to:*
> 1. 🔧 Fix existing bugs in the application
> 2. 📑 Create an employee resource and implement default CRUD operations
> 3. 🧮 Implement an endpoint to provide salary metrics about employees

>💡 *The Phoenix application is an API*

## 🏋️ Preparation

I feel fortunate to have received the exercise link from [Chris](https://www.linkedin.com/in/christopherjsharpe/) right after my interview. I quickly skimmed through it, taking a look at the README to get a general sense of the exercise. However, I did not yet bother to dive into the codebase as per his recommendation to work on this properly after the second interview.

In preparation for the Hiring Manager interview which was reading the public [Remote Handbook](https://remotecom.notion.site/a3439c6ccaac4d5f8c7515c357345c11?v=8bb7f9be662f45da87ef4ab14a42be37), I took a [multiplex](https://remotecom.notion.site/Working-Async-at-Remote-80c01cd443ad4c77a8ceaef7c5fba5d0#421984f91f8e498db9f27cf05f08ea7e)ed approach by immersing myself in learning Elixir and Phoenix for the first time. Here's what I did beforehand:

1. **Exploring [Elixir](https://elixir-lang.org/)**: I accessed Elixir and watched the fascinating Elixir [mini-documentary](https://youtu.be/lxYFOM3UJzo) by HoneyPot. It was captivating to learn about the history, capabilities, the rise in popularity explained by the inventor himself, José Valim.

2. **Resource Research**: I searched for recommended resources that catered to experienced engineers. I managed to acquire the following valuable resources:

    - **[Elixir & OTP](https://pragmaticstudio.com/courses/elixir) by The Pragmatic Studio**: This video series provided me with a comprehensive birds-eye-view of Elixir's syntax, technical terminologies, and design principles. I chose not to code along to focus on gaining a solid understanding of the concepts. In my opinion, this is one of the best courses available due to its direct and concise approach.

    - **[The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/course/the-complete-elixir-and-phoenix-bootcamp-and-tutorial) by Stephen Girder**: Understanding that simply reading books or watching tutorials wouldn't suffice, I decided to take a plunge into this course. It allowed me to dive into the water and test my newly acquired knowledge. At this point, I was already preparing my [local environment](#-development-set-up). I progressed more than halfway since I did not expect the course to be that long. Although I made significant progress, I had to cut it short as I scheduled the next interview in an early date.

## 🖥️ Development Set Up

### 🤦 Configuring a Custom Dev Container
When I started following the tutorials, I realized the importance of setting up a development environment. My plan was to create a [Dev Container](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for each project from the courses. The idea of creating a Dev Container for each project using VSCode amazed me. It was so convenient to open the project folder and let VSCode handle the configuration. Rather than sticking through normal installation, I tinkered on setting up my own. I thought it would be the same as `docker/-compose`. However, to no avail I failed to create one and it's already taking some time.

### 🚀 Into VSCode

I had no idea that VSCode had such a powerful extension until now. Previously, I primarily used VSCode for quick notes and as a scratch pad, while relying on [PHPStorm](https://www.jetbrains.com/phpstorm/) (or any JetBrains IDE) for my main work. Unfortunately, PHPStorm lacked support for `.devcontainers` and only has a [plugin](https://plugins.jetbrains.com/plugin/7522-elixir) support for Elixir. This pushed me to jump ship to VSCode, much like how I [hop](https://en.wiktionary.org/wiki/distro-hopping) between different Linux distributions. Besides, my paid license for PHPStorm is about to expire anyway. The only downside was having to reconfigure my key bindings.

### ⌨️ Familiarizing `asdf`

The next recommendation on the list was to set up my environment using [asdf](https://asdf-vm.com/guide/introduction.html). It was my first time using asdf, and I wanted to establish multiple versions to align with the tutorials and exercise requirements. I successfully configured a global config and managed to bind projects to specific versions using their `.tool-versions` file. For this exercise, my `current asdf` is:

```bash
elixir          1.12.1-otp-24
erlang          24.3.4.11
postgres        11.9
```

I encountered some errors with Erlang `24.0.2`, so I opted for `24.3.4.11`, derived from my already available global install, which worked fine. One limitation I noticed was the inability to run multiple instances of Postgres simultaneously due to port conflicts (`port:5432`). Therefore, I had to use `pg_ctl stop/start` for each project.

### ⚙️ Applications & Browser Tabs

- **OS**: [Pop!_OS](https://pop.system76.com/)
- **Browser**: [Firefox](https://www.mozilla.org/en-US/)
- **IDE**: Visual Studio Code with terminal
- **DB Client**: [pgAdmin](https://www.pgadmin.org/)
- **API Testing**: [Postman](https://www.postman.com/home)

Tabs Opened:

- [DuckDuckGo](https://duckduckgo.com/)
- [Elixir Forum](https://elixirforum.com)
- Hexdocs - Basically spammed the search bar and been particular on the versions since later versions had more functions
    - [Phoenix v1.5.9](https://hexdocs.pm/phoenix/1.5.9/overview.html#content)
    - [Elixir v1.12.1](https://hexdocs.pm/elixir/1.12.1/api-reference.html#content)
    - [Ecto v.3.6.2](https://hexdocs.pm/ecto/3.6.2/getting-started.html#content)
    - [Plug v1.11](https://hexdocs.pm/plug/1.11.1/readme.html#content)
    - [ExUnit v1.11.2](https://hexdocs.pm/ex_unit/1.11.2/ExUnit.html#content)


## 🌈 The Solution

I was able to:

### 1. 🔧 Fix existing bugs in the application

Found the issues and corrected them. `mix test` did the trick! Initially, I thought the application was plagued with numerous bugs. However, I did not implement the currency conversion service due to a design decision.

### 2. 📑 Create an employee resource and implement default CRUD operations
> *The application already has two resources: `country` and `currency`. You will have to create an `employee` resource and implement default [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations.*

Woah! The two predefined resources helped me. The [MVC](https://developer.mozilla.org/en-US/docs/Glossary/MVC)s are already there as well and are greate references for this task. All I need to do is to find out how to generate a scaffold for employee.

#### 🌳 Employee Context vs Countries Context

Paused for a while and noticed that Countries context has country and currency under it. I was confused if I would define employees in its own context or would it be under the Countries context? Initially, created as a context, and spotted it's a bit off knowing that the employee has a strong relationship with currency and country. Tried out putting under the Countries context and got confused even further from the pre-emptive warning from Phoenix stating the number of functions it already has. I finally decided to put it in the same context for the sake of cohesion.

> *It must have a*
> * *full name*
> * *job title*
> * *country*
> * *salary*
> * *currency in which the salary is paid*

#### 💱 Currency Field

I pondered whether a currency field was necessary for employees since the country already has a currency associated with it. Initially, I thought chaining the relationship between the employee and country would suffice. However, I realized that some employees might prefer to be paid in a different currency than their own country's currency. For instance, an employee might request to be paid in Japanese Yen due to an upcoming trip to 🇯🇵 Japan.

To accommodate such scenarios, I included the `currency_id` for employees, allowing them to specify the currency in which their salary is paid.

Here's the `phx.gen*` to generate the scaffold:

```console
mix phx.gen.json Countries Employee employees full_name job_title salary:decimal country_id:references:countries currency_id:references:currencies
```

#### 🌱 Seeding

> *Add the logic to seed 10 000 employees into the database. Seed data lives on the [`priv/repo/seeds.exs`](priv/repo/seeds.exs) file.*

I created an `Employee.Seeds` module in the [priv/repo/seeds.exs](priv/repo/seeds.exs) file to handle the seeding process. Since 10,000 records inserted at once could take a while and potentially cause unhandled errors, I decided not to [chunk](https://en.wikipedia.org/wiki/Chunking_(computing)) the insertions for now, considering the manageable number of records.

To ensure data integrity, I wrapped the [`Repo.insert!/2`](https://hexdocs.pm/ecto/3.6.2/Ecto.Repo.html#c:insert!/2) function within a [`Repo.transaction/2`](https://hexdocs.pm/ecto/3.6.2/Ecto.Repo.html#c:transaction/2) block. This way, if any insertion failed, the entire transaction would be rolled back.

> *For the seeds, the following data fields have data that must be used for their generation:*
>
> * *full name to be generated by reading and combining data found in [`/priv/data/first_names.txt`](/priv/data/first_names.txt) and [`/priv/data/last_names.txt`](/priv/data/first_names.txt)*
>* *job title to be generated from a subset of values found in [`/priv/data/job_titles.txt`](/priv/data/job_titles.txt) - please use a subset of 100 job titles from the provided list*
>
>*There is no defined logic to what first name should go with what last name, job title, country etc. Assign them as you see fit.*

Generally, the `file_to_list/1` converted these `"\n"` separated value files to a list and I worked my way utilizing `Enum.*` functions.

For each field I used the following logic:

- **full name** - Randomly picked a first and last name from their corresponding `.txt` file and combined through string interpolation.
- **job title** - Shuffled the list of job titles then took the upper 100 as a subset. Basically, it works like shuffling a deck of cards and taking a certain number from the stack.
- **salary** - Generated a random number from 1 to 1000 and then multiplied to 1000. I wanted to have good looking salaries that end in "000"es. Meaning, the seeded salaries can range from 1 000 and 1 000 000.
- **currency_id/country_id** - Since the seeding order is `currency > country > employee`, the currency and country IDs are already created beforehand. Through a database query, I stored the IDs in a list and randomly assigned them to each employee.

#### 💲Salaries in 🇺🇸 USD

I am a firm believer of having clean and consistent data, where data transformation should only happen on the application level.

For the sake of unblemished and coherent data, I decided to store salaries in **United States Dollars (USD)**. This eliminates the need for immediate currency conversion since employees can specify their preferred currency separately. Therefore, the conversion rates have fixed values, and the map of conversion rates must have keys in the format `"USD<TO>"`.

### 3. 🧮 Implement an endpoint to provide salary metrics about employees

> - *Given a country, the minimum, maximum, and average salary in that country.*
> - *Given a job title, the average salary for all the employees with that job title.*

Route: `GET     /api/salaries/:filter`

The `:filter` can either be a country name, country code, or a job title. The country name or code takes precedence over job title. When a country is not found, it then searches for a job title. A `404 Not Found` is spit out whenever none is found or whenever it does not follow the validation format.

Choosed this logic to have a simpler yet flexible approach. The only downside of not having the key-based [query string](https://en.wikipedia.org/wiki/Query_string) is the possibility of having equal values. For example, filtering for the job title "CEO" and having an existing same country code, yields the country metrics result.

The final value for salary is rounded off.

I placed it in a separate context, because it is more of a data manipulation and presentation layer and it does not have its own schema. Further down the line, it may contain functions that utilize the currency conversion service.

## 💾 Data Modeling & Relationships

> *Use your best judgement when modelling the data and relationships.*

To ensure data integrity and define relationships, I defined database constraints and validation rules in both the migrations and changesets. Here are some key details:

- **Employee**: The `salary` field is specified with a `precision` of 10 and a `scale` of 2, allowing for accurate representation of decimal values. When performing calculations on salaries using database aggregate functions, the results are rounded off for consistency.

- **Currency** & **Country**: Similar constraints and validations are defined for the currency and country tables as well.

By carefully defining these constraints and validations, we ensure that the data stored in the database remains consistent and accurate.

### 🗄️ Database Tables

```sql
                    Table "currencies"
   Column    |              Type              | Nullable
-------------+--------------------------------+----------
 id          | bigint                         | not null
 code        | character varying(3)           | not null
 name        | character varying(255)         | not null
 symbol      | character varying(3)           | not null
 inserted_at | timestamp(0) without time zone | not null
 updated_at  | timestamp(0) without time zone | not null
Indexes:
    "currencies_pkey" PRIMARY KEY, btree (id)
    "currencies_code_index" UNIQUE, btree (code)
    "currencies_name_index" UNIQUE, btree (name)
Referenced by:
    TABLE "countries" CONSTRAINT "countries_currency_id_fkey"
        FOREIGN KEY (currency_id) REFERENCES currencies(id)
    TABLE "employees" CONSTRAINT "employees_currency_id_fkey"
        FOREIGN KEY (currency_id) REFERENCES currencies(id)
```

```sql
                    Table "countries"
   Column    |              Type              | Nullable
-------------+--------------------------------+----------
 id          | bigint                         | not null
 name        | character varying(255)         | not null
 code        | character varying(3)           | not null
 currency_id | bigint                         | not null
 inserted_at | timestamp(0) without time zone | not null
 updated_at  | timestamp(0) without time zone | not null
Indexes:
    "countries_pkey" PRIMARY KEY, btree (id)
    "countries_code_index" UNIQUE, btree (code)
    "countries_name_index" UNIQUE, btree (name)
    "countries_currency_id_index" btree (currency_id)
Foreign-key constraints:
    "countries_currency_id_fkey"
        FOREIGN KEY (currency_id) REFERENCES currencies(id)
Referenced by:
    TABLE "employees" CONSTRAINT "employees_country_id_fkey"
        FOREIGN KEY (country_id) REFERENCES countries(id)
```

```sql
                    Table "employees"
   Column    |              Type              | Nullable
-------------+--------------------------------+----------
 id          | bigint                         | not null
 full_name   | character varying(255)         | not null
 job_title   | character varying(255)         | not null
 salary      | numeric(10,2)                  | not null
 country_id  | bigint                         | not null
 currency_id | bigint                         | not null
 inserted_at | timestamp(0) without time zone | not null
 updated_at  | timestamp(0) without time zone | not null
Indexes:
    "employees_pkey" PRIMARY KEY, btree (id)
    "employees_country_id_index" btree (country_id)
    "employees_currency_id_index" btree (currency_id)
Foreign-key constraints:
    "employees_country_id_fkey"
        FOREIGN KEY (country_id) REFERENCES countries(id)
    "employees_currency_id_fkey"
        FOREIGN KEY (currency_id) REFERENCES currencies(id)
```

### 🧑‍🤝‍🧑 Entity-Relationship Diagram

![alt text](priv/repo/er_diagram.png "ER Diagram")

### ✔️ Validation Rules

To ensure data integrity and enforce consistency, the following validation rules are applied to the fields:

- All fields are required

- Codes must be three alphabet characters in ALL caps

- Country and currency names must be capitalized

- Fields of type `:string` are maxed to 255 characters

- Salary should be greater than zero

In case any of the validation rules are not met, an appropriate error message is displayed, and the response status code is set to `422 Unprocessable Entity`.

## 🛣️ The Extra Mile

I went above and beyond to add some additional features to enhance the functionality and security of the application. Here are the details:

### ✂️ Trim Request *(disabled, tests fail)* 😢

Inspired by Laravel's trim request [middleware](https://laravel.com/docs/10.x/requests#input-trimming-and-normalization), I attempted to introduce a similar functionality as a plug. The idea was to trim leading and trailing Unicode whitespaces from the values of `conn.params` that are of type `:string`, but only for the `POST`, `PUT`, or `PATCH` HTTP methods. I added this plug to the pipeline.

For example, creating an employee with the request body of:

```json
{
    "employee": {
        "full_name": "           My Dad Wrote My Name From Right to Left",
        "job_title": "    A Job that requires spaces    ",
        "salary": 10000,
        "country_id": 1,
        "currency_id": 1
    }
}
```

responds with:

```json
{
    "data": {
        "full_name": "My Dad Wrote My Name From Right to Left",
        "id": 10001,
        "job_title": "A Job that requires spaces",
        "salary": "10000"
    }
}
```

⚠️ However, the tests started **failing**, leading to its temporary removal from the pipeline. Addressing the test failures and re-enabling the feature could be a future improvement.

### 🔑 Token Bearer Authentication

Integrated an [HTTP authentication](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication) feature to the REST API through the [Bearer](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication) token scheme on all endpoints. It should be part of the HTTP request header as `Bearer <token_here>`. The token is a [Phoenix.Token](https://hexdocs.pm/phoenix/1.5.9/Phoenix.Token.html#content) signed and verified using the `:secret_key_base` and `"asin"` as salt. Missing or wrong token results to `401 Unauthorized`.

To enhance the security of the API, I implemented token-based authentication using the [Bearer](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication) token scheme. The authentication token should be included in the HTTP request header as `Bearer <your_token_here>`.

The token is generated using [Phoenix.Token](https://hexdocs.pm/phoenix/1.5.9/Phoenix.Token.html#content), which is signed and verified using the `:secret_key_base` and `"asin"` as the salt. The generated token is printed after the [installation](#-installation) process. To generate a new token, you can run **`mix token`** in the project directory.

## ℹ️ Implementation Details

> *Moreover, if there is something you had to leave incomplete or there is a better solution you would implement but couldn’t due to personal time constraints, please try to walk us through your thought process or any missing parts, using the “Implementation Details”*

- Re-write and PASS the tests to include the [Trim Request](#-trim-request-disabled-tests-fail-) feature
- Pass the excluded tests. As per `mix test`, it has `3 excluded` tests. These are functional on and end-to-end testing, but fail on tests. The tests are on changesets with `unique_constraint`s where I was trying to assert a failure on trying to create duplicate records.
- Better test coverage, as per `mix test --cover`, `77.16%`
- [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) tests
- A more intuitive Employee `create` and `update` where the prerequisites of an existing Currency or Country is not mandatory. Add the ability to create non-existing valid currency or country under the same employee endpoint.
- Conform to [JSON API](https://jsonapi.org/) and [OpenAPI](https://swagger.io/specification/) specifications
- More secure authentication, I was thinking of creating a separate endpoint to obtain an expirable token and use that token on all secured endpoints
- ISO based [country](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3#Officially_assigned_code_elements) and [currency](https://en.wikipedia.org/wiki/ISO_4217#List_of_ISO_4217_currency_codes) name and code validations, or better, have these seeded
- I tried to generate an [ExDoc](https://hexdocs.pm/ex_doc/readme.html) but decided to scrap it off, It is just too messy and it is not that organized.
- Create a external currency conversion API

## 🏫 Other Learning Resources

- [Build a JSON API with Phoenix](https://lobotuerto.com/notes/build-a-json-api-with-phoenix) by Víctor Adrián. Showed me the how-to's in creating a Phoenix based JSON API.
- [Yet Another Guide To Build a JSON API with Phoenix 1.5](https://www.poeticoding.com/another-guide-to-build-a-json-api-with-phoenix-1-5/) by Tamas Soos
- [Simple token authentication for Phoenix API](https://dev.to/mnishiguchi/simple-token-authentication-for-phoenix-json-api-1m05) by Masatoshi Nishiguchi
- [Phoenix Token for API-auth, salt per user or per app?](https://elixirforum.com/t/phoenix-token-for-api-auth-salt-per-user-or-per-app/13361)
- [Elixir: When to use .ex and when .exs files](https://stackoverflow.com/questions/36292620/elixir-when-to-use-ex-and-when-exs-files)

---

## 🎤 Feedback
> *Take whatever time you need - we won’t look at start/end dates, you have a life besides this and we respect that!*

I took advantage of untimed exercise by further exploring things. Basically, it became a "trial-and-error". Every amusing feature that I touch, I dwell on the documentation, reading its description. Not only do I have to settle on my tests passing, I figure out a way if there is still a better approach on my code, especially adhering to the *"Elixir Way"*

There was a time I asked myself if there is a way to include the related resource. Found out it was possible through `Preload`. I implemented it on the `:index` and `:show` routes. I was satisfied with the `.json` views. Then, the testing came, and my tests are `FAIL`ing. I ended up reverting everything back just to satisfy `PASS`ing my tests.

Another instance was when I was trying to create a good regular expression for [`validate_format/4`](https://hexdocs.pm/ecto/3.6.2/Ecto.Changeset.html#validate_format/4) for job title. I thought of just a simple capitalization rule. However, when I did a mix `ecto.reset`, the transaction rolled back and pointed out that "**e**Commerce Marketing Specialist" was the reason. I had no choice but just to scrap out the validation rule. 😀

> *Was it too short/big? Boring? Let us know!*

I appreciated the clarity of the instructions and the specific requirements outlined for each task. This allowed me to focus on implementing the necessary functionality and ensured that I understood the expectations clearly.

The exercise was not only a testament of coding skills, but also a brief coverage of system design. On how someone came into decision, the reason, the trade-offs. The assignment is short but it is up to the applicant to make it big.

As a task for an experienced backend engineer but with no Elixir background, the exercise captures the general feel of implementing the "Phoenix approach." While working and at the same time learning, I can't help but compare Phoenix to other web frameworks I worked on.

The closest that came to my mind was Laravel. Right even at the start of the installation, I kept on searching if there is a [Laravel sail](https://laravel.com/docs/10.x/sail)-like approach on setting up a local environment on Phoenix. It is none existent so I had to stick with asdf.Phoenix has `iex` as Laravel has `php artisan tinker`. Pipeline and plugs in Phoenix as middleware is to Laravel. Moreover, they differ on the validation approach. Phoenix has changesets that are tightly coupled to the schema while Laravel recommends validation rules definitions inside controllers. Then this triggered my curiosity, on what if we were to create a changeset that needs some validations but could not have a schema. Without searching for a solution, I first thought maybe it would need to create a struct just to emulate a schema. Dug deeper and found out about [schemaless changesets](https://hexdocs.pm/ecto/Ecto.Changeset.html#module-schemaless-changesets).

As per the [Naming issues](https://remotecom.notion.site/The-Remote-Flow-d90982e77a144f4f990c135f115f41c6) in the Remote Flow, I adopted the **High Context + Low Context Pattern** as naming conventions for my `git commit -m`essages.

## 🤯 Insights

### 🕹️ From OO to Functional Programming

Elixir changed my way of thinking. Way back in university days, Java was my first programming language. While working on this task, I need to unwrap my head on what I've used to, the object-oriented approach. It is a beginner's way of thinking since we can relate these objects to actual real-world objects that have properties and behaviors. Now in functional programming, everything is immutable, unlike in OO where the change of state is through creating an instance and the methods that define it. In FP, data structures are somewhat changed through a duplication and transformation of data.

### ⚗️ Elixir Features

I was captivated by Elixir, and here's my notable features:

#### 👙 Pattern Matching

Pattern matching is an elegant way of extracting data and assigning variables. It works like a filter. I am amazed that I was still at the part of typing in the function arguments, I am already doing some logic behind it. The same also applies to function guards.

#### 🏛️ Function Clauses

At first I thought function clauses worked like the method overloading concept in OO due to having the same function names. And to my surprise, it is a cleaner approach to declutter a long chain of conditionals where the way of ordering actually matters.

#### 🪃 ~~Return Statement~~ 

n Elixir, the last expression in a function is automatically considered the return value. At least, I no longer need to type `return`. There was a time I was trying to do an early return. To my astonishment, there is none, so I used pattern matching and guard as a substitute.

#### 🪠 `|>`iping

Piping offers a cleaner approach where variable usage is declared once. It is one of Elixir's distinct syntax, and initially I was confused on how to read that block of code. It just came along when I was already redeclaring variables and re-inputting them as parameters. Works like a pattern recognition that when my brain recognizes a repeatable pattern, The brain says, 🧠: *"Hey, Pipe it!"* I might have still missed some though, especially in some of my messy tests.

#### 🧱 Rich Data Structures

Initially, the data structures was a bit overwhelming since I have been used to the PHP approach where everything generally translates to just an array. 😆

#### 📄+🧪 DocTest

Amazed on @doc, where the documentation creation is also for testing purposes. I was astonished as how easy it is to tinker in `iex>` the copy the command and output as the `## Examples`. For someone who sometimes skips the description, and goes right in the examples, this feature is extremely helpful.

### ✍️ If I were to Restart...

Knowing what I learned through this exercise, I would take the [TDD](https://en.wikipedia.org/wiki/Test-driven_development) route by starting writing tests and API validations first.

## 💓 Acknowledgement

Huge shoutouts to [Chris](https://www.linkedin.com/in/christopherjsharpe/) and [Stepan](https://www.linkedin.com/in/sreznikov/), very welcoming interviews. Lastly, and definitely not the least, my wife, 🤰***Grace*** that scolds 💢 at me everytime I punch 👊 my desk due to failing tests. 🤮