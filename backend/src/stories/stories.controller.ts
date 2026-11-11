
import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';

import { StoriesService } from './stories.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('stories')
export class StoriesController {
  constructor(
    private readonly storiesService: StoriesService,
  ) {}

  // Get all published stories.
  @Get()
  getAllStories() {
    return this.storiesService.findAllPublished();
  }

  // Publish a story (login required).
  @UseGuards(JwtAuthGuard)
  @Post()
  createStory(
    @Body()
    body: {
      title: string;
      content: string;
      language: string;
    },
    @Req() req: any,
  ) {
    return this.storiesService.create(
      body.title,
      body.content,
      body.language,
      req.user.userId,
    );
  }
}
