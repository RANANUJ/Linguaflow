import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';

import { Story } from './schemas/story.schema';

@Injectable()
export class StoriesService {
  constructor(
    @InjectModel(Story.name)
    private readonly storyModel: Model<Story>,
  ) {}

  // Create and save a new story in MongoDB.
  async create(
    title: string,
    content: string,
    language: string,
    userId: string,
  ): Promise<Story> {
    const story = new this.storyModel({
      title,
      content,
      language,
      userId: new Types.ObjectId(userId),
      isPublished: true,
    });

    return story.save();
  }

  // Get all published stories.
  async findAllPublished(): Promise<Story[]> {
    return this.storyModel
      .find({
        isPublished: true,
      })
      .sort({
        createdAt: -1,
      })
      .exec();
  }
}