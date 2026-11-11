import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcrypt';

import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { User, UserDocument } from '../users/schemas/user.schema';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name)
    private readonly userModel: Model<UserDocument>,
    private readonly jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto) {
    // Convert the email to lowercase for consistent storage.
    const email = registerDto.email.toLowerCase();

    // Check whether this email is already registered.
    const existingUser = await this.userModel.findOne({ email });

    if (existingUser) {
      throw new ConflictException(
        'An account with this email already exists.',
      );
    }

    // Hash the password before saving it in MongoDB.
    const hashedPassword = await bcrypt.hash(registerDto.password, 10);

    // Create and save the new user.
    const user = await this.userModel.create({
      name: registerDto.name,
      email,
      password: hashedPassword,
    });

    // Never return the password or hashed password to the app.
    return {
      message: 'Account created successfully.',
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
      },
    };
  }

  async login(loginDto: LoginDto) {
    // Find the user using their email.
    const email = loginDto.email.toLowerCase();

    const user = await this.userModel.findOne({ email });

    if (!user) {
      throw new UnauthorizedException('Invalid email or password.');
    }

    // Compare the entered password with the hashed password.
    const isPasswordCorrect = await bcrypt.compare(
      loginDto.password,
      user.password,
    );

    if (!isPasswordCorrect) {
      throw new UnauthorizedException('Invalid email or password.');
    }

    // This information is stored inside the JWT token.
    const payload = {
      sub: user._id.toString(),
      email: user.email,
    };

    // Create a signed JWT access token.
    const accessToken = await this.jwtService.signAsync(payload);

    return {
      message: 'Login successful.',
      accessToken,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
      },
    };
  }
}