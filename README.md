# Projekt Restaurace Backend
Toto je README k backendu aplikace restaurace. Frontend je taktéž veřejný git repozitář zde: https://github.com/dusekjan/restaurace_FE
Doporučuji spouštět projekt v některém vývojovém prostředí, které dokáže samo najít aplikaci a spustit ji. 
Projekt je samozřejmě možné spustit i klasickými následujícími příkazy v hlavním adresáři:

## Instalace závislostí před prvním spuštěním
`pip install -r requirements.txt`

## Spuštění backend části v debug módu (nutné pokud frontend běží na localhost:3000)
`python -m flask run --host=localhost --debug` poté aplikace běží na `localhost:5000`

## Spuštění backend části bez debug módu
`python -m flask run --host=localhost` poté aplikace běží na `localhost:5000`

## Databáze
Dazabáze se nemusí pouštět zvlášť, ale je připraven script pro naplnění, která se spouští příkazem `flask init-db` - budou smazána všechna aktuální data a 
naplní se ukázkovými. Plnící script je v souboru `.\database\schema.sql`

### Uživatelé
Do aplikace je možné se přihlásit jakýmkoliv účtem
 - libovolný uživatel s rolí 'user' - má nastavené heslo na 'user' a má email ve formátu user1@user.cz, user2@user.cz a tak dále
 - libovolný uživatel s rolí 'admin' - má nastavené heslo na 'admin' a má email ve formátu admin1@admin.cz, admin2@admin.cz a tak dále                           

### Užitečné informace
Frontend je ReactJS aplikace, kterou je při vývoji možné spustit na `localhost:3000`.
#### Backend běží v debug módu:
 - Backend v tomto módu umožňuje komunikovat s `localhost:3000` - toto je ideální řešení během vývoje frontendu. 
 - Pokud je ve stejném adresáři i složka s frontend částí, pak po navštívení stránky `localhost:5000`, bude backend brát data ze složky ..\restaurant_FE\build 
 (což je výsledek po `npm run build` v adresáři frontendu). 
#### Backend neběží v debug módu:
 - Backend neumožňuje ukládat cookies, tudíž neumožňuje komunikaci s jinými než s `localhost:5000` adresou.
 - Backend servíruje data ze složky .\build což je produkční build (`npm run build`) aplikace ReactJS.
