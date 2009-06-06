<%args>
$chars => 2
</%args>
<%init>
return $chars == 3 ? {
	AFG => 'AFGHANISTAN',
	CAF => 'AFRICA',
	ALB => 'ALBANIA',
	ALG => 'ALGERIA',
	ASM => 'AMERICAN SAMOA',
	AND => 'ANDORRA',
	ANG => 'ANGOLA',
	AGU => 'ANGUILLA',
	ANT => 'ANTIGUA',
	APO => 'APO',
	ARG => 'ARGENTINA',
	ARM => 'ARMENIA',
	ARU => 'ARUBA',
	AUS => 'AUSTRALIA',
	AUT => 'AUSTRIA',
	AZO => 'AZORES',
	BAH => 'BAHAMAS',
	BRN => 'BAHRAIN',
	BAN => 'BANGLADESH',
	BAR => 'BARBADOS',
	BAB => 'BARBUDA',
	BLR => 'BELARUS',
	BEL => 'BELGIUM',
	BIZ => 'BELIZE',
	BEN => 'BENIN',
	BER => 'BERMUDA',
	BHU => 'BHUTAN',
	BOL => 'BOLIVIA',
	BON => 'BONAIRE N.A.',
	BOP => 'BOPHUTHATSWANA',
	BOS => 'BOSNIA',
	BOT => 'BOTSWANA',
	BRA => 'BRAZIL',
	BRU => 'BRUNEI',
	BUL => 'BULGARIA',
	VOL => 'BURKINA FASO',
	BIR => 'BURMA',
	BDI => 'BURUNDI',
	CMR => 'CAMEROON',
	CAN => 'CANADA',
	CNY => 'CANARY ISLANDS',
	CAY => 'CAYMAN ISLANDS',
	CHD => 'CHAD',
	CNI => 'CHANNEL ISLANDS',
	CHI => 'CHILE',
	CHN => 'CHINA',
	COL => 'COLOMBIA',
	COI => 'COMORO ISLANDS',
	COG => 'CONGO',
	CKI => 'COOK ISLANDS',
	CRC => 'COSTA RICA',
	CRO => 'CROATIA',
	CUB => 'CUBA',
	CUR => 'CURACAO N.A.',
	CYP => 'CYPRUS',
	TCH => 'CZECH REPUBLIC',
	NKR => 'KOREA',
	YMD => 'YEMEN',
	DEM => 'DENMARK',
	DCA => 'DOMINICA',
	DOM => 'DOMINICAN REPUBLIC',
	ECU => 'ECUADOR',
	EGY => 'EGYPT',
	ESA => 'EL SALVADOR',
	GBR => 'ENGLAND',
	EQG => 'EQUATORIAL GUINEA',
	EST => 'ESTONIA',
	ETH => 'ETHIOPIA',
	FRI => 'FAEROE ISLANDS',
	FIJ => 'FIJI',
	FIN => 'FINLAND',
	FPO => 'FPO',
	FRA => 'FRANCE',
	FGI => 'FRENCH GUIANA',
	FPN => 'FRENCH POLYNESIA',
	GAB => 'GABON',
	GAM => 'GAMBIA',
	GER => 'GERMANY',
	GHA => 'GHANA',
	GIB => 'GIBRALTAR',
	GRE => 'GREECE',
	GDA => 'GRENADA',
	GDL => 'GUADELOUPE',
	GUM => 'GUAM',
	GUA => 'GUATEMALA',
	GUI => 'GUINEA',
	GBI => 'GUINEA-BISSAU',
	GUY => 'GUYANA',
	HAI => 'HAITI',
	HON => 'HONDURAS',
	HKG => 'HONG KONG',
	HUN => 'HUNGARY',
	ISL => 'ICELAND',
	IND => 'INDIA',
	INA => 'INDONESIA',
	IRN => 'IRAN',
	IRQ => 'IRAQ',
	IRL => 'IRELAND',
	IOM => 'ISLE OF MAN',
	IRS => 'ISRAEL',
	ITA => 'ITALY',
	IVC => 'IVORY COAST',
	JAM => 'JAMAICA',
	JPN => 'JAPAN',
	JOR => 'JORDAN',
	KEN => 'KENYA',
	KIR => 'KIRIBATI',
	KUW => 'KUWAIT',
	LAO => 'LAOS',
	LAT => 'LATVIA',
	LIB => 'LEBANON',
	LES => 'LESOTHO',
	LBR => 'LIBERIA',
	LBA => 'LIBYA',
	LIE => 'LIECHTENSTEIN',
	LIT => 'LITHUANIA',
	LUX => 'LUXEMBOURG',
	MAC => 'MACAO',
	MKD => 'MACEDONIA',
	MAD => 'MADAGASCAR',
	MAW => 'MALAWI',
	MAL => 'MALAYSIA',
	MLI => 'MALI',
	MLT => 'MALTA',
	MRT => 'MARTINIQUE FWI',
	MAU => 'MAURITANIA',
	MRI => 'MAURITIUS',
	MYT => 'MAYOTTE',
	MEX => 'MEXICO',
	MOL => 'MOLDOVA',
	MON => 'MONACO',
	MNG => 'MONGOLIA',
	MTS => 'MONTSERRAT',
	MAR => 'MOROCCO',
	MOZ => 'MOZAMBIQUE',
	NAB => 'NAMIBIA',
	NAR => 'NAURU',
	NEP => 'NEPAL',
	AHO => 'NETH. ANTILLES',
	HOL => 'NETHERLANDS',
	NEV => 'NEVIS',
	NCL => 'NEW CALEDONIA',
	NZL => 'NEW ZEALAND',
	NCA => 'NICARAGUA',
	NIG => 'NIGER',
	NGR => 'NIGERIA',
	NOI => 'NORTHERN IRELAND',
	NOR => 'NORWAY',
	OMA => 'OMAN',
	PAK => 'PAKISTAN',
	PAN => 'PANAMA',
	NGU => 'PAPUA NEW GUINEA',
	PAR => 'PARAGUAY',
	PER => 'PERU',
	PHI => 'PHILIPPINES',
	POL => 'POLAND',
	POR => 'PORTUGAL',
	PUE => 'PUERTO RICO',
	QAT => 'QATAR',
	CAP => 'CAPE VERDE',
	ROD => 'DJIBOUTI',
	RGE => 'GEORGIA',
	KOR => 'KOREA',
	RMD => 'MALDIVES',
	SAF => 'SOUTH AFRICA',
	REU => 'REUNION',
	ROM => 'ROMANIA',
	URS => 'RUSSIA',
	RWA => 'RWANDA',
	SAB => 'SABA N.A.',
	SAI => 'SAIPAN',
	SAO => 'SAO TOME',
	SAU => 'SAUDI ARABIA',
	SCO => 'SCOTLAND',
	SCN => 'SENEGAL',
	SEY => 'SEYCHELLES',
	SLE => 'SIERRA LEONE',
	SIN => 'SINGAPORE',
	SLV => 'SLOVAKIA',
	SLO => 'SLOVENIA',
	SLI => 'SOLOMON ISLANDS',
	SOM => 'SOMALIA',
	SAF => 'SOUTH AFRICA',
	SPA => 'SPAIN',
	SRI => 'SRI LANKA',
	STB => 'ST BARTHELEMY FWI',
	SCR => 'ST CHRISTOPHER',
	STC => 'ST CROIX',
	STE => 'ST EUSTATIUS N.A.',
	SJM => 'ST JAMES',
	STJ => 'ST JOHN',
	STK => 'ST KITTS',
	STL => 'ST LUCIA',
	SMR => 'ST MAARTEN N.A.',
	STM => 'ST MARTIN FWI',
	SPM => 'ST PIERRE',
	STT => 'ST THOMAS',
	STV => 'ST VINCENT',
	SUD => 'SUDAN',
	SUR => 'SURINAM',
	SWZ => 'SWAZILAND',
	SWE => 'SWEDEN',
	SUI => 'SWITZERLAND',
	SYR => 'SYRIA',
	TAH => 'TAHITI',
	TPE => 'TAIWAN',
	TAN => 'TANZANIA',
	TTP => 'TER. PACIFIC ISLES',
	THA => 'THAILAND',
	TIB => 'TIBET',
	TOB => 'TOBAGO',
	TOG => 'TOGO',
	TON => 'TONGA',
	TRN => 'TRANSKEI',
	TRI => 'TRINIDAD',
	TUN => 'TUNISIA',
	TUR => 'TURKEY',
	TAC => 'TURKS &amp; CAICOS',
	TUV => 'TUVALU',
	EGA => 'UGANDA',
	UKR => 'UKRAINE',
	UAE => 'ARAB',
	BGR => 'UNITED KINGDOM',
	URU => 'URUGUAY',
	USA => 'USA',
	VAN => 'VANUATU',
	VAT => 'VATICAN CITY',
	VEN => 'VENEZUELA',
	NVT => 'VIETNAM',
	BVI => 'VIRGIN ISLANDS',
	BWI => 'WEST INDIES',
	WLS => 'WALES',
	WAL => 'WALLIS ARCHIPELAGO',
	WEI => 'WEST INDIES',
	WSH => 'WESTERN SAHARA',
	WSM => 'WESTERN SAMOA',
	WIN => 'WINDWARD ISLANDS',
	YAR => 'YEMEN ARAB REP.',
	YUG => 'YUGOSLAVIA',
	ZAI => 'ZAIRE',
	ZAM => 'ZAMBIA',
	ZIM => 'ZIMBABWE',
}
: {
	'AR' => 'Argentina*',
	'AU' => 'Australia',
	'AT' => 'Austria',
	'BS' => 'Bahamas',
	'BE' => 'Belgium',
	'BR' => 'Brazil',
	'CA' => 'Canada*',
	'CL' => 'Chile',
	'CR' => 'Costa Rica',
	'DK' => 'Denmark*',
	'DO' => 'Dominican Republic',
	'FI' => 'Finland',
	'FR' => 'France*',
	'DE' => 'Germany*',
	'GR' => 'Greece',
	'GT' => 'Guatemala',
	'HK' => 'Hong Kong',
	'IE' => 'Ireland',
	'IL' => 'Israel',
	'IT' => 'Italy',
	'MY' => 'Malaysia',
	'MX' => 'Mexico',
	'NL' => 'Netherlands',
	'NZ' => 'New Zealand',
	'NO' => 'Norway',
	'PA' => 'Panama',
	'PT' => 'Portugal',
	'PR' => 'Puerto Rico',
	'SG' => 'Singapore',
	'ES' => 'Spain',
	'SE' => 'Sweden',
	'CH' => 'Switzerland',
	'TW' => 'Taiwan',
	'GB' => 'United Kingdom',
	'US' => 'United States',
	'AL' => 'Albania',
	'DZ' => 'Algeria',
	'AS' => 'American Samoa',
	'AD' => 'Andorra',
	'AO' => 'Angola',
	'AI' => 'Anguilla',
	'AG' => 'Antigua and Barbuda',
	'AR' => 'Argentina',
	'AM' => 'Armenia*',
	'AW' => 'Aruba',
	'AU' => 'Australia*',
	'AT' => 'Austria*',
	'AZ' => 'Azerbaijan*',
	'AP' => 'Azores*',
	'BS' => 'Bahamas',
	'BH' => 'Bahrain',
	'BD' => 'Bangladesh*',
	'BB' => 'Barbados',
	'BY' => 'Belarus*',
	'BE' => 'Belgium*',
	'BZ' => 'Belize',
	'BJ' => 'Benin',
	'BM' => 'Bermuda',
	'BT' => 'Bhutan',
	'BO' => 'Bolivia',
	'BL' => 'Bonaire',
	'BA' => 'Bosnia and Herzegovina*',
	'BW' => 'Botswana',
	'BV' => 'Bouvet Island',
	'BR' => 'Brazil*',
	'IO' => 'British Indian Ocean Territory',
	'BN' => 'Brunei Darussalam',
	'BG' => 'Bulgaria*',
	'BF' => 'Burkina Faso',
	'BI' => 'Burundi',
	'KH' => 'Cambodia',
	'CM' => 'Cameroon',
	'CA' => 'Canada*',
	'IC' => 'Canary Islands*',
	'CV' => 'Cape Verde',
	'KY' => 'Cayman Islands',
	'CF' => 'Central African Republic',
	'TD' => 'Chad',
	'CD' => 'Channel Islands',
	'CL' => 'Chile',
	'CN' => 'China*',
	'CX' => 'Christmas Island',
	'CC' => 'Cocos (Keeling) Islands',
	'CO' => 'Colombia',
	'KM' => 'Comoros',
	'ZP' => 'Congo (Democratic Republic of)',
	'CK' => 'Cook Islands',
	'CR' => 'Costa Rica',
	'CI' => 'Cote D\'Ivoire (Ivory Coast)',
	'HR' => 'Croatia (Hrvatska)*',
	'CB' => 'Curacao',
	'CY' => 'Cyprus*',
	'CZ' => 'Czech Republic*',
	'DK' => 'Denmark',
	'DJ' => 'Djibouti',
	'DM' => 'Dominica',
	'DO' => 'Dominican Republic',
	'TP' => 'East Timor',
	'EC' => 'Ecuador',
	'EG' => 'Egypt',
	'SV' => 'El Salvador',
	'EN' => 'England*',
	'GQ' => 'Equatorial Guinea',
	'ER' => 'Eritrea',
	'EE' => 'Estonia*',
	'ET' => 'Ethiopia',
	'FO' => 'Faeroe Islands*',
	'FK' => 'Falkland Islands (Malvinas)',
	'FJ' => 'Fiji',
	'FI' => 'Finland*',
	'FR' => 'France',
	'GF' => 'French Guiana',
	'PF' => 'French Polynesia',
	'TF' => 'French Southern Territories',
	'GA' => 'Gabon',
	'GM' => 'Gambia',
	'GE' => 'Georgia*',
	'DE' => 'Germany*',
	'GH' => 'Ghana',
	'GI' => 'Gibraltar',
	'GB' => 'United Kingdom (Great Britain)*',
	'GR' => 'Greece*',
	'GL' => 'Greenland*',
	'GD' => 'Grenada',
	'GP' => 'Guadeloupe',
	'GU' => 'Guam*',
	'GT' => 'Guatemala',
	'GN' => 'Guinea',
	'GW' => 'Guinea-Bissau',
	'GY' => 'Guyana',
	'HT' => 'Haiti',
	'HM' => 'Heard Island and McDonald Islands',
	'HN' => 'Honduras',
	'HK' => 'Hong Kong',
	'HU' => 'Hungary*',
	'IS' => 'Iceland*',
	'IN' => 'India',
	'ID' => 'Indonesia*',
	'IE' => 'Ireland',
	'IL' => 'Israel*',
	'IT' => 'Italy*',
	'JM' => 'Jamaica',
	'JP' => 'Japan*',
	'JO' => 'Jordan',
	'KZ' => 'Kazakhstan*',
	'KE' => 'Kenya',
	'KI' => 'Kiribati',
	'KO' => 'Kosrae*',
	'KW' => 'Kuwait',
	'KG' => 'Kyrgyzstan*',
	'LA' => 'Laos',
	'LV' => 'Latvia*',
	'LB' => 'Lebanon',
	'LS' => 'Lesotho',
	'LR' => 'Liberia',
	'LY' => 'Libya',
	'LI' => 'Liechtenstein*',
	'LT' => 'Lithuania*',
	'LU' => 'Luxembourg*',
	'MO' => 'Macau',
	'MK' => 'Macedonia*',
	'MG' => 'Madagascar',
	'ME' => 'Madeira*',
	'MW' => 'Malawi',
	'MY' => 'Malaysia*',
	'MV' => 'Maldives',
	'ML' => 'Mali',
	'MT' => 'Malta*',
	'MH' => 'Marshall Islands*',
	'MQ' => 'Martinique*',
	'MR' => 'Mauritania',
	'MU' => 'Mauritius',
	'YT' => 'Mayotte',
	'MX' => 'Mexico*',
	'FM' => 'Micronesia*',
	'MD' => 'Moldova*',
	'MC' => 'Monaco*',
	'MN' => 'Mongolia',
	'MS' => 'Montserrat',
	'MA' => 'Morocco',
	'MZ' => 'Mozambique*',
	'MM' => 'Myanmar',
	'NA' => 'Namibia',
	'NR' => 'Nauru',
	'NP' => 'Nepal*',
	'NL' => 'Netherlands*',
	'AN' => 'Netherlands Antilles',
	'NT' => 'Neutral Zone',
	'NC' => 'New Caledonia',
	'NZ' => 'New Zealand (Aotearoa)*',
	'NI' => 'Nicaragua',
	'NE' => 'Niger',
	'NG' => 'Nigeria',
	'NU' => 'Niue',
	'NF' => 'Norfolk Island',
	'KP' => 'North Korea',
	'NB' => 'Northern Ireland*',
	'MP' => 'Northern Mariana Islands',
	'NO' => 'Norway*',
	'OM' => 'Oman',
	'PK' => 'Pakistan*',
	'PW' => 'Palau*',
	'PA' => 'Panama',
	'PG' => 'Papua New Guinea',
	'PY' => 'Paraguay',
	'PE' => 'Peru',
	'PH' => 'Philippines*',
	'PN' => 'Pitcairn',
	'PL' => 'Poland*',
	'PO' => 'Ponape*',
	'PT' => 'Portugal*',
	'PR' => 'Puerto Rico*',
	'QA' => 'Qatar',
	'RE' => 'Reunion*',
	'RO' => 'Romania*',
	'RT' => 'Rota',
	'RU' => 'Russian Federation*',
	'RW' => 'Rwanda',
	'SS' => 'Saba',
	'KN' => 'Saint Kitts and Nevis',
	'LC' => 'Saint Lucia',
	'VC' => 'Saint Vincent and the Grenadines',
	'SP' => 'Saipan',
	'WS' => 'Samoa',
	'SM' => 'San Marino*',
	'ST' => 'Sao Tome and Principe',
	'SA' => 'Saudi Arabia*',
	'SF' => 'Scotland*',
	'SN' => 'Senegal',
	'SC' => 'Seychelles',
	'SL' => 'Sierra Leone',
	'SG' => 'Singapore*',
	'SK' => 'Slovak Republic*',
	'SI' => 'Slovenia*',
	'SB' => 'Solomon Islands',
	'SO' => 'Somalia',
	'ZA' => 'South Africa*',
	'GS' => 'South Georgia and South Sandwich Islands',
	'KR' => 'South Korea*',
	'ES' => 'Spain*',
	'LK' => 'Sri Lanka*',
	'NT' => 'St. Barthelemy',
	'SW' => 'St. Christopher',
	'VI' => 'St. Croix*',
	'EU' => 'St. Eustatius',
	'SH' => 'St. Helena',
	'UV' => 'St. John*',
	'KN' => 'St. Kitts and Nevis',
	'LC' => 'St. Lucia',
	'MB' => 'St. Maarten',
	'TB' => 'St. Martin',
	'PM' => 'St. Pierre and Miquelon',
	'VL' => 'St. Thomas*',
	'VC' => 'St. Vincent/Grenadine',
	'SD' => 'Sudan',
	'SR' => 'Suriname',
	'SJ' => 'Svalbard and Jan Mayen Islands',
	'SZ' => 'Swaziland',
	'SE' => 'Sweden*',
	'CH' => 'Switzerland*',
	'SY' => 'Syria',
	'TA' => 'Tahiti',
	'TW' => 'Taiwan*',
	'TJ' => 'Tajikistan*',
	'TZ' => 'Tanzania',
	'TH' => 'Thailand*',
	'TI' => 'Tinian',
	'TG' => 'Togo',
	'TK' => 'Tokelau',
	'TO' => 'Tonga',
	'TL' => 'Tortola',
	'TT' => 'Trinidad and Tobago',
	'TU' => 'Truk*',
	'TN' => 'Tunisia',
	'TR' => 'Turkey*',
	'TM' => 'Turkmenistan*',
	'TC' => 'Turks and Caicos Islands',
	'TV' => 'Tuvalu',
	'UG' => 'Uganda',
	'UA' => 'Ukraine*',
	'UI' => 'Union Island',
	'AE' => 'United Arab Emirates',
	'US' => 'United States*',
	'UY' => 'Uruguay*',
	'UM' => 'US Minor Outlying Islands',
	'SU' => 'USSR (former)',
	'UZ' => 'Uzbekistan*',
	'VU' => 'Vanuatu',
	'VA' => 'Vatican City State (Holy See)*',
	'VE' => 'Venezuela',
	'VN' => 'Vietnam*',
	'VR' => 'Virgin Gorda',
	'VG' => 'Virgin Islands (British)',
	'VI' => 'Virgin Islands (U.S.)*',
	'WL' => 'Wales*',
	'WF' => 'Wallis and Futuna Islands',
	'WS' => 'Western Samoa',
	'YA' => 'Yap*',
	'YE' => 'Yemen',
	'YU' => 'Yugoslavia',
	'ZR' => 'Zaire',
	'ZM' => 'Zambia',
	'ZW' => 'Zimbabwe',
};
</%init>

	         
	         


<%method .license>

Copyright 1999-2009 Randy Harmon

Hod is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or   
(at your option) any later version.

Hod is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
GNU General Public License for more details (in the LICENSE file).           
    
You should have received a copy of the GNU General Public License
along with Hod.  If not, see <http://www.gnu.org/licenses/>.

</%method>