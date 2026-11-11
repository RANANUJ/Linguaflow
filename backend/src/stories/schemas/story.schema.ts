import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';

export type StoryDocument = HydratedDocument<Story>;

@Schema({
  timestamps: true,
})
export class Story {
  @Prop({
    required: true,
    trim: true,
  })
  title: string;

  @Prop({
    required: true,
    trim: true,
  })
  content: string;

  // The language in which the user originally wrote the story.
  @Prop({
    required: true,
    trim: true,
    default: 'English',
  })
  language: string;

  // The MongoDB user ID of the person who created the story.
  // We will automatically connect this to the logged-in user
  // in the next steps.
  @Prop({
    type: Types.ObjectId,
    ref: 'User',
    required: true,
  })
  userId: Types.ObjectId;

  // A story is visible to other users only after publishing.
  @Prop({
    default: true,
  })
  isPublished: boolean;
}

export const StorySchema = SchemaFactory.createForClass(Story);