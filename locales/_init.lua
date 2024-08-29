Locales = {}

function Language(index)
    return Locales[Config.Locale][index] or 'does_not_exist'
end