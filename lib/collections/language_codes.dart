class ISOLanguageName {
  final String name;
  final String nativeName;

  const ISOLanguageName({
    required this.name,
    required this.nativeName,
  });

  @override
  String toString() {
    return "$name ($nativeName)";
  }
}

// Uncomment the languages as we add support for them
// Currently supported: bn,en,fr,hi,zh
abstract class LanguageLocals {
  static final Map isoLangs = {
    // "ab": const ISOLanguageName(
    //   name: "Abkhaz",
    //   nativeName: "аҧсуа",
    // ),
    // "aa": const ISOLanguageName(
    //   name: "Afar",
    //   nativeName: "Afaraf",
    // ),
    // "af": const ISOLanguageName(
    //   name: "Afrikaans",
    //   nativeName: "Afrikaans",
    // ),
    // "ak": const ISOLanguageName(
    //   name: "Akan",
    //   nativeName: "Akan",
    // ),
    // "sq": const ISOLanguageName(
    //   name: "Albanian",
    //   nativeName: "Shqip",
    // ),
    // "am": const ISOLanguageName(
    //   name: "Amharic",
    //   nativeName: "አማርኛ",
    // ),
    "ar": const ISOLanguageName(
      name: "Arabic",
      nativeName: "العربية",
    ),
    // "an": const ISOLanguageName(
    //   name: "Aragonese",
    //   nativeName: "Aragonés",
    // ),
    // "hy": const ISOLanguageName(
    //   name: "Armenian",
    //   nativeName: "Հայերեն",
    // ),
    // "as": const ISOLanguageName(
    //   name: "Assamese",
    //   nativeName: "অসমীয়া",
    // ),
    // "av": const ISOLanguageName(
    //   name: "Avaric",
    //   nativeName: "авар мацӀ, магӀарул мацӀ",
    // ),
    // "ae": const ISOLanguageName(
    //   name: "Avestan",
    //   nativeName: "avesta",
    // ),
    // "ay": const ISOLanguageName(
    //   name: "Aymara",
    //   nativeName: "aymar aru",
    // ),
    // "az": const ISOLanguageName(
    //   name: "Azerbaijani",
    //   nativeName: "azərbaycan dili",
    // ),
    // "bm": const ISOLanguageName(
    //   name: "Bambara",
    //   nativeName: "bamanankan",
    // ),
    // "ba": const ISOLanguageName(
    //   name: "Bashkir",
    //   nativeName: "башҡорт теле",
    // ),
    "eu": const ISOLanguageName(
      name: "Basque",
      nativeName: "Euskara",
    ),
    // "be": const ISOLanguageName(
    //   name: "Belarusian",
    //   nativeName: "Беларуская",
    // ),
    "bn": const ISOLanguageName(
      name: "Bengali",
      nativeName: "বাংলা",
    ),
    // "bh": const ISOLanguageName(
    //   name: "Bihari",
    //   nativeName: "भोजपुरी",
    // ),
    // "bi": const ISOLanguageName(
    //   name: "Bislama",
    //   nativeName: "Bislama",
    // ),
    // "bs": const ISOLanguageName(
    //   name: "Bosnian",
    //   nativeName: "bosanski jezik",
    // ),
    // "br": const ISOLanguageName(
    //   name: "Breton",
    //   nativeName: "brezhoneg",
    // ),
    // "bg": const ISOLanguageName(
    //   name: "Bulgarian",
    //   nativeName: "български език",
    // ),
    // "my": const ISOLanguageName(
    //   name: "Burmese",
    //   nativeName: "ဗမာစာ",
    // ),
    "ca": const ISOLanguageName(
      name: "Catalan",
      nativeName: "Català",
    ),
    // "ch": const ISOLanguageName(
    //   name: "Chamorro",
    //   nativeName: "Chamoru",
    // ),
    // "ce": const ISOLanguageName(
    //   name: "Chechen",
    //   nativeName: "нохчийн мотт",
    // ),
    // "ny": const ISOLanguageName(
    //   name: "Chichewa",
    //   nativeName: "chiCheŵa",
    // ),
    "zh_CN": const ISOLanguageName(
      name: "Simplified Chinese",
      nativeName: "简体中文",
    ),
    "zh_TW": const ISOLanguageName(
      name: "Traditional Chinese",
      nativeName: "繁體中文（台灣）",
    ),
    // "cv": const ISOLanguageName(
    //   name: "Chuvash",
    //   nativeName: "чӑваш чӗлхи",
    // ),
    // "kw": const ISOLanguageName(
    //   name: "Cornish",
    //   nativeName: "Kernewek",
    // ),
    // "co": const ISOLanguageName(
    //   name: "Corsican",
    //   nativeName: "lingua corsa",
    // ),
    // "cr": const ISOLanguageName(
    //   name: "Cree",
    //   nativeName: "ᓀᐦᐃᔭᐍᐏᐣ",
    // ),
    // "hr": const ISOLanguageName(
    //   name: "Croatian",
    //   nativeName: "hrvatski",
    // ),
    "cs": const ISOLanguageName(
      name: "Czech",
      nativeName: "česky, čeština",
    ),
    // "da": const ISOLanguageName(
    //   name: "Danish",
    //   nativeName: "dansk",
    // ),
    // "dv": const ISOLanguageName(
    //   name: "Maldivian;",
    //   nativeName: "ދިވެހި",
    // ),
    "nl": const ISOLanguageName(
      name: "Dutch",
      nativeName: "Nederlands",
    ),
    "en": const ISOLanguageName(
      name: "English",
      nativeName: "English",
    ),
    // "eo": const ISOLanguageName(
    //   name: "Esperanto",
    //   nativeName: "Esperanto",
    // ),
    // "et": const ISOLanguageName(
    //   name: "Estonian",
    //   nativeName: "eesti",
    // ),
    // "ee": const ISOLanguageName(
    //   name: "Ewe",
    //   nativeName: "Eʋegbe",
    // ),
    // "fo": const ISOLanguageName(
    //   name: "Faroese",
    //   nativeName: "føroyskt",
    // ),
    // "fj": const ISOLanguageName(
    //   name: "Fijian",
    //   nativeName: "vosa Vakaviti",
    // ),
    "fi": const ISOLanguageName(
      name: "Finnish",
      nativeName: "suomi",
    ),
    "fr": const ISOLanguageName(
      name: "French",
      nativeName: "français",
    ),
    // "ff": const ISOLanguageName(
    //   name: "Fula; Fulah; Pulaar; Pular",
    //   nativeName: "Fulfulde, Pulaar, Pular",
    // ),
    // "gl": const ISOLanguageName(
    //   name: "Galician",
    //   nativeName: "Galego",
    // ),
    "ka": const ISOLanguageName(
      name: "Georgian",
      nativeName: "ქართული",
    ),
    "de": const ISOLanguageName(
      name: "German",
      nativeName: "Deutsch",
    ),
    // "el": const ISOLanguageName(
    //   name: "Greek, Modern",
    //   nativeName: "Ελληνικά",
    // ),
    // "gn": const ISOLanguageName(
    //   name: "Guaraní",
    //   nativeName: "Avañeẽ",
    // ),
    // "gu": const ISOLanguageName(
    //   name: "Gujarati",
    //   nativeName: "ગુજરાતી",
    // ),
    // "ht": const ISOLanguageName(
    //   name: "Haitian; Haitian Creole",
    //   nativeName: "Kreyòl ayisyen",
    // ),
    // "ha": const ISOLanguageName(
    //   name: "Hausa",
    //   nativeName: "Hausa, هَوُسَ",
    // ),
    // "he": const ISOLanguageName(
    //   name: "Hebrew (modern)",
    //   nativeName: "עברית",
    // ),
    // "hz": const ISOLanguageName(
    //   name: "Herero",
    //   nativeName: "Otjiherero",
    // ),
    "hi": const ISOLanguageName(
      name: "Hindi",
      nativeName: "हिन्दी, हिंदी",
    ),
    // "ho": const ISOLanguageName(
    //   name: "Hiri Motu",
    //   nativeName: "Hiri Motu",
    // ),
    // "hu": const ISOLanguageName(
    //   name: "Hungarian",
    //   nativeName: "Magyar",
    // ),
    // "ia": const ISOLanguageName(
    //   name: "Interlingua",
    //   nativeName: "Interlingua",
    // ),
    "id": const ISOLanguageName(
      name: "Indonesian",
      nativeName: "Bahasa Indonesia",
    ),
    // "ie": const ISOLanguageName(
    //   name: "Interlingue",
    //   nativeName: "Occidental",
    // ),
    // "ga": const ISOLanguageName(
    //   name: "Irish",
    //   nativeName: "Gaeilge",
    // ),
    // "ig": const ISOLanguageName(
    //   name: "Igbo",
    //   nativeName: "Asụsụ Igbo",
    // ),
    // "ik": const ISOLanguageName(
    //   name: "Inupiaq",
    //   nativeName: "Iñupiaq, Iñupiatun",
    // ),
    // "io": const ISOLanguageName(
    //   name: "Ido",
    //   nativeName: "Ido",
    // ),
    // "is": const ISOLanguageName(
    //   name: "Icelandic",
    //   nativeName: "Íslenska",
    // ),
    "it": const ISOLanguageName(
      name: "Italian",
      nativeName: "Italiano",
    ),
    // "iu": const ISOLanguageName(
    //   name: "Inuktitut",
    //   nativeName: "ᐃᓄᒃᑎᑐᑦ",
    // ),
    "ja": const ISOLanguageName(
      name: "Japanese",
      nativeName: "日本語",
    ),
    // "jv": const ISOLanguageName(
    //   name: "Javanese",
    //   nativeName: "basa Jawa",
    // ),
    // "kl": const ISOLanguageName(
    //   name: "Kalaallisut, Greenlandic",
    //   nativeName: "kalaallisut, kalaallit oqaasii",
    // ),
    // "kn": const ISOLanguageName(
    //   name: "Kannada",
    //   nativeName: "ಕನ್ನಡ",
    // ),
    // "kr": const ISOLanguageName(
    //   name: "Kanuri",
    //   nativeName: "Kanuri",
    // ),
    // "ks": const ISOLanguageName(
    //   name: "Kashmiri",
    //   nativeName: "कश्मीरी, كشميري‎",
    // ),
    // "kk": const ISOLanguageName(
    //   name: "Kazakh",
    //   nativeName: "Қазақ тілі",
    // ),
    // "km": const ISOLanguageName(
    //   name: "Khmer",
    //   nativeName: "ភាសាខ្មែរ",
    // ),
    // "ki": const ISOLanguageName(
    //   name: "Kikuyu, Gikuyu",
    //   nativeName: "Gĩkũyũ",
    // ),
    // "rw": const ISOLanguageName(
    //   name: "Kinyarwanda",
    //   nativeName: "Ikinyarwanda",
    // ),
    // "ky": const ISOLanguageName(
    //   name: "Kirghiz, Kyrgyz",
    //   nativeName: "кыргыз тили",
    // ),
    // "kv": const ISOLanguageName(
    //   name: "Komi",
    //   nativeName: "коми кыв",
    // ),
    // "kg": const ISOLanguageName(
    //   name: "Kongo",
    //   nativeName: "KiKongo",
    // ),
    "ko": const ISOLanguageName(
      name: "Korean",
      nativeName: "한국어 (韓國語), 조선말 (朝鮮語)",
    ),
    // "ku": const ISOLanguageName(
    //   name: "Kurdish",
    //   nativeName: "Kurdî, كوردی‎",
    // ),
    // "kj": const ISOLanguageName(
    //   name: "Kwanyama, Kuanyama",
    //   nativeName: "Kuanyama",
    // ),
    // "la": const ISOLanguageName(
    //   name: "Latin",
    //   nativeName: "latine, lingua latina",
    // ),
    // "lb": const ISOLanguageName(
    //   name: "Luxembourgish, Letzeburgesch",
    //   nativeName: "Lëtzebuergesch",
    // ),
    // "lg": const ISOLanguageName(
    //   name: "Luganda",
    //   nativeName: "Luganda",
    // ),
    // "li": const ISOLanguageName(
    //   name: "Limburgish, Limburgan, Limburger",
    //   nativeName: "Limburgs",
    // ),
    // "ln": const ISOLanguageName(
    //   name: "Lingala",
    //   nativeName: "Lingála",
    // ),
    // "lo": const ISOLanguageName(
    //   name: "Lao",
    //   nativeName: "ພາສາລາວ",
    // ),
    // "lt": const ISOLanguageName(
    //   name: "Lithuanian",
    //   nativeName: "lietuvių kalba",
    // ),
    // "lu": const ISOLanguageName(
    //   name: "Luba-Katanga",
    //   nativeName: "",
    // ),
    // "lv": const ISOLanguageName(
    //   name: "Latvian",
    //   nativeName: "latviešu valoda",
    // ),
    // "gv": const ISOLanguageName(
    //   name: "Manx",
    //   nativeName: "Gaelg, Gailck",
    // ),
    // "mk": const ISOLanguageName(
    //   name: "Macedonian",
    //   nativeName: "македонски јазик",
    // ),
    // "mg": const ISOLanguageName(
    //   name: "Malagasy",
    //   nativeName: "Malagasy fiteny",
    // ),
    // "ms": const ISOLanguageName(
    //   name: "Malay",
    //   nativeName: "bahasa Melayu, بهاس ملايو‎",
    // ),
    // "ml": const ISOLanguageName(
    //   name: "Malayalam",
    //   nativeName: "മലയാളം",
    // ),
    // "mt": const ISOLanguageName(
    //   name: "Maltese",
    //   nativeName: "Malti",
    // ),
    // "mi": const ISOLanguageName(
    //   name: "Māori",
    //   nativeName: "te reo Māori",
    // ),
    // "mr": const ISOLanguageName(
    //   name: "Marathi (Marāṭhī)",
    //   nativeName: "मराठी",
    // ),
    // "mh": const ISOLanguageName(
    //   name: "Marshallese",
    //   nativeName: "Kajin M̧ajeļ",
    // ),
    // "mn": const ISOLanguageName(
    //   name: "Mongolian",
    //   nativeName: "монгол",
    // ),
    // "na": const ISOLanguageName(
    //   name: "Nauru",
    //   nativeName: "Ekakairũ Naoero",
    // ),
    // "nv": const ISOLanguageName(
    //   name: "Navajo, Navaho",
    //   nativeName: "Diné bizaad, Dinékʼehǰí",
    // ),
    // "nb": const ISOLanguageName(
    //   name: "Norwegian Bokmål",
    //   nativeName: "Norsk bokmål",
    // ),
    // "nd": const ISOLanguageName(
    //   name: "North Ndebele",
    //   nativeName: "isiNdebele",
    // ),
    "ne": const ISOLanguageName(
      name: "Nepali",
      nativeName: "नेपाली",
    ),
    // "ng": const ISOLanguageName(
    //   name: "Ndonga",
    //   nativeName: "Owambo",
    // ),
    // "nn": const ISOLanguageName(
    //   name: "Norwegian Nynorsk",
    //   nativeName: "Norsk nynorsk",
    // ),
    // "no": const ISOLanguageName(
    //   name: "Norwegian",
    //   nativeName: "Norsk",
    // ),
    // "ii": const ISOLanguageName(
    //   name: "Nuosu",
    //   nativeName: "ꆈꌠ꒿ Nuosuhxop",
    // ),
    // "nr": const ISOLanguageName(
    //   name: "South Ndebele",
    //   nativeName: "isiNdebele",
    // ),
    // "oc": const ISOLanguageName(
    //   name: "Occitan",
    //   nativeName: "Occitan",
    // ),
    // "oj": const ISOLanguageName(
    //   name: "Ojibwe, Ojibwa",
    //   nativeName: "ᐊᓂᔑᓈᐯᒧᐎᓐ",
    // ),
    // "cu": const ISOLanguageName(
    //   name: "Old Church Slavonic",
    //   nativeName: "ѩзыкъ словѣньскъ",
    // ),
    // "om": const ISOLanguageName(
    //   name: "Oromo",
    //   nativeName: "Afaan Oromoo",
    // ),
    // "or": const ISOLanguageName(
    //   name: "Oriya",
    //   nativeName: "ଓଡ଼ିଆ",
    // ),
    // "os": const ISOLanguageName(
    //   name: "Ossetian, Ossetic",
    //   nativeName: "ирон æвзаг",
    // ),
    // "pa": const ISOLanguageName(
    //   name: "Panjabi, Punjabi",
    //   nativeName: "ਪੰਜਾਬੀ, پنجابی‎",
    // ),
    // "pi": const ISOLanguageName(
    //   name: "Pāli",
    //   nativeName: "पाऴि",
    // ),
    "fa": const ISOLanguageName(
      name: "Persian",
      nativeName: "فارسی",
    ),
    "pl": const ISOLanguageName(
      name: "Polish",
      nativeName: "polski",
    ),
    // "ps": const ISOLanguageName(
    //   name: "Pashto, Pushto",
    //   nativeName: "پښتو",
    // ),
    "pt": const ISOLanguageName(
      name: "Portuguese",
      nativeName: "Português",
    ),
    // "qu": const ISOLanguageName(
    //   name: "Quechua",
    //   nativeName: "Runa Simi, Kichwa",
    // ),
    // "rm": const ISOLanguageName(
    //   name: "Romansh",
    //   nativeName: "rumantsch grischun",
    // ),
    // "rn": const ISOLanguageName(
    //   name: "Kirundi",
    //   nativeName: "kiRundi",
    // ),
    // "ro": const ISOLanguageName(
    //   name: "Romanian, Moldavian, Moldovan",
    //   nativeName: "română",
    // ),
    "ru": const ISOLanguageName(
      name: "Russian",
      nativeName: "русский язык",
    ),
    // "sa": const ISOLanguageName(
    //   name: "Sanskrit (Saṁskṛta)",
    //   nativeName: "संस्कृतम्",
    // ),
    // "sc": const ISOLanguageName(
    //   name: "Sardinian",
    //   nativeName: "sardu",
    // ),
    // "sd": const ISOLanguageName(
    //   name: "Sindhi",
    //   nativeName: "सिन्धी, سنڌي، سندھی‎",
    // ),
    // "se": const ISOLanguageName(
    //   name: "Northern Sami",
    //   nativeName: "Davvisámegiella",
    // ),
    // "sm": const ISOLanguageName(
    //   name: "Samoan",
    //   nativeName: "gagana faa Samoa",
    // ),
    // "sg": const ISOLanguageName(
    //   name: "Sango",
    //   nativeName: "yângâ tî sängö",
    // ),
    // "sr": const ISOLanguageName(
    //   name: "Serbian",
    //   nativeName: "српски језик",
    // ),
    // "gd": const ISOLanguageName(
    //   name: "Scottish Gaelic; Gaelic",
    //   nativeName: "Gàidhlig",
    // ),
    // "sn": const ISOLanguageName(
    //   name: "Shona",
    //   nativeName: "chiShona",
    // ),
    // "si": const ISOLanguageName(
    //   name: "Sinhala, Sinhalese",
    //   nativeName: "සිංහල",
    // ),
    // "sk": const ISOLanguageName(
    //   name: "Slovak",
    //   nativeName: "slovenčina",
    // ),
    // "sl": const ISOLanguageName(
    //   name: "Slovene",
    //   nativeName: "slovenščina",
    // ),
    // "so": const ISOLanguageName(
    //   name: "Somali",
    //   nativeName: "Soomaaliga, af Soomaali",
    // ),
    // "st": const ISOLanguageName(
    //   name: "Southern Sotho",
    //   nativeName: "Sesotho",
    // ),
    "es": const ISOLanguageName(
      name: "Spanish",
      nativeName: "español",
    ),
    // "su": const ISOLanguageName(
    //   name: "Sundanese",
    //   nativeName: "Basa Sunda",
    // ),
    // "sw": const ISOLanguageName(
    //   name: "Swahili",
    //   nativeName: "Kiswahili",
    // ),
    // "ss": const ISOLanguageName(
    //   name: "Swati",
    //   nativeName: "SiSwati",
    // ),
    // "sv": const ISOLanguageName(
    //   name: "Swedish",
    //   nativeName: "svenska",
    // ),
    "ta": const ISOLanguageName(
      name: "Tamil",
      nativeName: "தமிழ்",
    ),
    // "te": const ISOLanguageName(
    //   name: "Telugu",
    //   nativeName: "తెలుగు",
    // ),
    // "tg": const ISOLanguageName(
    //   name: "Tajik",
    //   nativeName: "тоҷикӣ, toğikī, تاجیکی‎",
    // ),
    "th": const ISOLanguageName(
      name: "Thai",
      nativeName: "ไทย",
    ),
    // "ti": const ISOLanguageName(
    //   name: "Tigrinya",
    //   nativeName: "ትግርኛ",
    // ),
    // "bo": const ISOLanguageName(
    //   name: "Tibetan Standard, Tibetan, Central",
    //   nativeName: "བོད་ཡིག",
    // ),
    // "tk": const ISOLanguageName(
    //   name: "Turkmen",
    //   nativeName: "Türkmen, Түркмен",
    // ),
    "tl": const ISOLanguageName(
      name: "Tagalog",
      nativeName: "Wikang Tagalog",
    ),
    // "tn": const ISOLanguageName(
    //   name: "Tswana",
    //   nativeName: "Setswana",
    // ),
    // "to": const ISOLanguageName(
    //   name: "Tonga (Tonga Islands)",
    //   nativeName: "faka Tonga",
    // ),
    "tr": const ISOLanguageName(
      name: "Turkish",
      nativeName: "Türkçe",
    ),
    // "ts": const ISOLanguageName(
    //   name: "Tsonga",
    //   nativeName: "Xitsonga",
    // ),
    // "tt": const ISOLanguageName(
    //   name: "Tatar",
    //   nativeName: "татарча, tatarça, تاتارچا‎",
    // ),
    // "tw": const ISOLanguageName(
    //   name: "Twi",
    //   nativeName: "Twi",
    // ),
    // "ty": const ISOLanguageName(
    //   name: "Tahitian",
    //   nativeName: "Reo Tahiti",
    // ),
    // "ug": const ISOLanguageName(
    //   name: "Uighur, Uyghur",
    //   nativeName: "Uyƣurqə, ئۇيغۇرچە‎",
    // ),
    "uk": const ISOLanguageName(
      name: "Ukrainian",
      nativeName: "українська",
    ),
    // "ur": const ISOLanguageName(
    //   name: "Urdu",
    //   nativeName: "اردو",
    // ),
    // "uz": const ISOLanguageName(
    //   name: "Uzbek",
    //   nativeName: "zbek, Ўзбек, أۇزبېك‎",
    // ),
    // "ve": const ISOLanguageName(
    //   name: "Venda",
    //   nativeName: "Tshivenḓa",
    // ),
    "vi": const ISOLanguageName(
      name: "Vietnamese",
      nativeName: "Tiếng Việt",
    ),
    // "vo": const ISOLanguageName(
    //   name: "Volapük",
    //   nativeName: "Volapük",
    // ),
    // "wa": const ISOLanguageName(
    //   name: "Walloon",
    //   nativeName: "Walon",
    // ),
    // "cy": const ISOLanguageName(
    //   name: "Welsh",
    //   nativeName: "Cymraeg",
    // ),
    // "wo": const ISOLanguageName(
    //   name: "Wolof",
    //   nativeName: "Wollof",
    // ),
    // "fy": const ISOLanguageName(
    //   name: "Western Frisian",
    //   nativeName: "Frysk",
    // ),
    // "xh": const ISOLanguageName(
    //   name: "Xhosa",
    //   nativeName: "isiXhosa",
    // ),
    // "yi": const ISOLanguageName(
    //   name: "Yiddish",
    //   nativeName: "ייִדיש",
    // ),
    // "yo": const ISOLanguageName(
    //   name: "Yoruba",
    //   nativeName: "Yorùbá",
    // ),
    // "za": const ISOLanguageName(
    //   name: "Zhuang, Chuang",
    //   nativeName: "Saɯ cueŋƅ, Saw cuengh",
    // )
  };

  static ISOLanguageName getDisplayLanguage(String key, String? countryCode) {
    if (isoLangs.containsKey(key)) {
      return isoLangs[key]!;
    } else if (countryCode != null &&
        countryCode.isNotEmpty &&
        isoLangs.containsKey("${key}_$countryCode")) {
      return isoLangs["${key}_$countryCode"]!;
    } else {
      throw Exception("Language key incorrect");
    }
  }
}
