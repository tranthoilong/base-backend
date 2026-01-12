import {
    registerDecorator,
    ValidationArguments,
    ValidationOptions
  } from "class-validator";
  import { BANNED_WORDS } from "../constants/";
  
  function normalize(text: string): string {
    return text
      .toLowerCase()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .replace(/[^a-z0-9]/g, "");
  }
  
  export function NoBannedWord(validationOptions?: ValidationOptions) {
    return function (object: Object, propertyName: string) {
      registerDecorator({
        name: "NoBannedWord",
        target: object.constructor,
        propertyName,
        options: validationOptions,
        validator: {
          validate(value: string) {
            if (!value) return true;

            const normalizedValue = normalize(value);

            // Lấy tất cả words từ tất cả categories và tạo array phẳng
            const allBannedWords = Object.values(BANNED_WORDS)
              .flatMap(category => category.words);

            return !allBannedWords.some(word =>
              normalizedValue.includes(normalize(word))
            );
          }
        }
      });
    };
  }
  