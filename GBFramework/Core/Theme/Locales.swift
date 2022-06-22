//
//  Locales.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import Foundation

class Locales {

    static var current = "ru_RU"
    static var currentShort = "ru"

    static func value(_ key: String) -> String {
        return data[key] ?? ""
    }

    static func getOrderSettingName(_ code: String) -> String {
        return value(code)
    }

    static private let data: [String:String] = [
        "dialog_title_warning": "Внимание!",
        "dialog_text_beforeShowPathYouHaveToStopLocationObserving": "Сначала необходимо остановить слежение",
        "dialog_button_okStop": "ОК",

        "toast_login_error": "Введите корректный логин",
        "toast_password_error": "Введите корректный пароль",

        "vc_login_prompt_login": "Логин",
        "vc_login_prompt_password": "Пароль",
        "vc_login_button_signIn": "Вход",
        "vc_login_button_signUp": "Регистрация",

        "vc_map_button_path": "Предыдущий маршрут",
        "vc_map_button_start": "Начать новый трек",
        "vc_map_button_end": "Закончить трек",

        "vc_register_title": "Регистрация",
    ]
}
