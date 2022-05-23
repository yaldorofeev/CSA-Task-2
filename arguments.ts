import 'dotenv/config';

export default [
  process.env.UNISWAP_CONTRACT as string,
  process.env.SUPER_TOKEN_CONTRACT as string,
  10,
  30,
  5
];
