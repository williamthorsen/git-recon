// Usage: deno run --allow-read scripts/helpers/readVersionNumber.ts

/**
 * Reads the value of `VERSION` from the `metadata.ts` file and logs it to the console.
 * Intended for use in bash scripts.
 */
import { metadata } from '../../metadata.ts';
console.log(metadata.version);
