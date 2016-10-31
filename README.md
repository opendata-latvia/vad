VAD
===

Datu savākšana
---------------

Rekomendējam izmantot Google Chrome pārlūkprogrammu.
Uzinstalējiet [Tampermonkey paplašinājumu Google Chrome](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo
).

Uzinstalējiet [VAD datu savākšanas skriptu](https://vad.opendata.lv/vid-vad-vici.user.js).

Sāciet [savākt datus](https://www6.vid.gov.lv/vid_pdb/vad).

Izdomājiet unikālu projekta nosaukumu, ko ievadīt Projekts laukā.
Ja jūs esat ar e-pasta adresi `@xxx.lv`, tad rekomendējam visiem jūsu projektiem izmantot `xxx` prefiksu, piemēram, `xxx2016`
(lai varētu atpazīt, kas izmanto kurus projektus).

Apmēram ik pēc 10 deklarācijām (kas savāktas no vienas IP adreses), parādīsies popup logs, kur jāievada CAPTCHA kods.
Tiek parādīti divi vārdi, bet pārbaudīts tiek tikai viens - parasti tas ir vienkāršākais vārds, kā, piemēram, "road", "route", "calle" vai kas tamlīdzīgs.
Pietiek ievadīt šo vienu vienkāršāko vārdu. Ja nav skaidrs, kas jāievada, var ievadīt jebko un tad parādīsies nākamie vārdi.

Parametros var atzīmēt "Automātiska CAPTCHA aizpilde" un tad daudzas reizes automātiski tiks mēģināts aizpildīt biežāk lietoto CAPTCHA kodu,
ja tas neizdosies, tad beigās varēs ievadīt kodu manuāli.

Datu apskate
------------

Pieslēdzieties [VAD](https://vad.opendata.lv) ar jūsu e-pastu un paroli.

Pārslēdzieties uz tabu [Importēt deklarācijas](https://vad.opendata.lv/import_declarations).
Tur jūs redzēsiet pēdējās savāktās deklarācijas ar statusu `new`.

Uzklikšķiniet uz jūsu projekta linka, lai atlasītu tikai jūsu projekta savāktās deklarācijas.
Uzklikšķiniet uz **Importēt visus**, lai ieimportētu visas jaunās deklarācijas - sagaidiet, līdz beidzas datu imports.

Pārslēdzieties uz tabu [Deklarācijas](https://vad.opendata.lv/declarations).
**Projekts** filtrā ierakstiet savu projekta nosaukumu, lai atfiltrētu tikai tās deklarācijas.

Papildus var veikt sekojošas filtrēšanas darbības:

* Ierakstiet teksta fragmentu, lai atlasītu rindas, kurās atbilstošajā laukā ir šis teksts.
* Ierakstiet `=xxx` vai `!=xxx`, lai atfiltrētu rindas ar precīzu vērtību `xxx` vai kas nav precīzi vienādas ar `xxx`.
* Ierakstiet skaitliskās kolonnās `<xxx`, `<=xxx`, `>xxx` vai `>=xxx`, lai atlasītu vērtības, kas ir mazākas vai lielākas par `xxx`.
* Uzklikšķiniet uz kolonnām, lai sakārtotu augošā vai dilstošā secībā.

Ja vēlaties izeksportēt atfiltrētos datus, tad lapas apakšā variet lejuplādēt datus CSV formātā.

Development environment preparation
-----------------------------------

Prerequisites

* Ruby 1.9.3
* MySQL
* Redis

Get repository and get Ruby gem dependencies

* `git clone git@github.com:opendata-latvia/vad.git`
* `cd vad`
* `gem install bundler`
* `bundle`

Create and verify configuration files

* `cp config/application.sample.yml config/application.yml`
* `cp config/database.sample.yml config/database.yml`

Create MySQL database schema

* `rake db:create`
* `rake db:migrate`

Running tests

* Run all tests with `rake spec`
* Run tests after each file change with `bundle exec guard`

License
-------

VAD is released under the MIT license (see file LICENSE).
