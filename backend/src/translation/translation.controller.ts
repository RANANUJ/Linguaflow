import {
  Body,
  Controller,
  Get,
  Post,
} from '@nestjs/common';

import { TranslationService } from './translation.service';

@Controller('translation')
export class TranslationController {
  constructor(
    private readonly translationService: TranslationService,
  ) {}

  @Post()
  async translate(
    @Body('text') text: string,
    @Body('targetLanguage') targetLanguage: string,
  ) {
    return this.translationService.translateText(
      text,
      targetLanguage,
    );
  }

  @Post('batch')
  async translateBatch(
    @Body('texts') texts: string[],
    @Body('targetLanguage') targetLanguage: string,
  ) {
    return this.translationService.translateBatch(
      texts,
      targetLanguage,
    );
  }

  @Get('languages')
  async getSupportedLanguages() {
    return this.translationService.getSupportedLanguages();
  }
}