export interface User {
  avatar: string;
  avatar_url: string;
  creation: Date;
  date: Date;
  discriminator: string;
  id: string;
  public_flags: number;
  request_count: number;
  username: string;
  bot: boolean;
}
