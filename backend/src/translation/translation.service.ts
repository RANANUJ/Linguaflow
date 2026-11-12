
import {
  Injectable,
  InternalServerErrorException,
  BadRequestException,
} from '@nestjs/common';

import { ConfigService } from '@nestjs/config';
import axios from 'axios';

@Injectable()
export class TranslationService {
  constructor(private configService: ConfigService) {}

  // Translate a single text.
  async translateText(text: string, targetLanguage: string) {
    const key = this.configService.get<string>('AZURE_TRANSLATOR_KEY');
    const endpoint = this.configService.get<string>(
      'AZURE_TRANSLATOR_ENDPOINT',
    );
    const region = this.configService.get<string>(
      'AZURE_TRANSLATOR_REGION',
    );

    if (!key || !endpoint || !region) {
      throw new InternalServerErrorException(
        'Azure Translator configuration is missing.',
      );
    }

    try {
      const response = await axios.post(
        `${endpoint}/translate?api-version=3.0&to=${encodeURIComponent(targetLanguage)}`,
        [{ Text: text }],
        {
          headers: {
            'Ocp-Apim-Subscription-Key': key,
            'Ocp-Apim-Subscription-Region': region,
            'Content-Type': 'application/json',
          },
        },
      );

      return {
        originalText: text,
        translatedText: response.data[0].translations[0].text,
        targetLanguage,
      };
    } catch (error) {
      console.error('Azure Translator error:', error);

      throw new InternalServerErrorException(
        'Translation service is currently unavailable.',
      );
    }
  }

  // Translate multiple texts in one Azure request.
  async translateBatch(
    texts: string[],
    targetLanguage: string,
  ) {
    if (!texts || texts.length === 0 || !targetLanguage) {
      throw new BadRequestException(
        'Texts and target language are required.',
      );
    }

    const key = this.configService.get<string>('AZURE_TRANSLATOR_KEY');
    const endpoint = this.configService.get<string>(
      'AZURE_TRANSLATOR_ENDPOINT',
    );
    const region = this.configService.get<string>(
      'AZURE_TRANSLATOR_REGION',
    );

    if (!key || !endpoint || !region) {
      throw new InternalServerErrorException(
        'Azure Translator configuration is missing.',
      );
    }

    try {
      const requestBody = texts.map((text) => ({
        Text: text,
      }));

      const response = await axios.post(
        `${endpoint}/translate?api-version=3.0&to=${encodeURIComponent(targetLanguage)}`,
        requestBody,
        {
          headers: {
            'Ocp-Apim-Subscription-Key': key,
            'Ocp-Apim-Subscription-Region': region,
            'Content-Type': 'application/json',
          },
        },
      );

      return response.data.map((item: any, index: number) => ({
        originalText: texts[index],
        translatedText: item.translations[0].text,
        targetLanguage,
      }));
    } catch (error) {
      console.error('Azure batch translation error:', error);

      throw new InternalServerErrorException(
        'Batch translation service is currently unavailable.',
      );
    }
  }

  // Retrieve all languages supported by Azure Translator.
  async getSupportedLanguages() {
    const endpoint = this.configService.get<string>(
      'AZURE_TRANSLATOR_ENDPOINT',
    );

    if (!endpoint) {
      throw new InternalServerErrorException(
        'Azure Translator endpoint is missing.',
      );
    }

    try {
      const response = await axios.get(
        `${endpoint}/languages?api-version=3.0&scope=translation`,
      );

      return response.data.translation;
    } catch (error) {
      console.error('Azure languages error:', error);

      throw new InternalServerErrorException(
        'Unable to retrieve supported languages.',
      );
    }
  }
}
