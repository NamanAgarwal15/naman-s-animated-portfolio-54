import { Helmet } from "react-helmet-async";

type Props = {
  title: string;
  description: string;
  path: string;
  fullTitle?: string;
};

export default function SEO({ title, description, path, fullTitle }: Props) {
  const finalTitle = fullTitle ?? `${title} — Naman Agarwal`;
  return (
    <Helmet>
      <title>{finalTitle}</title>
      <meta name="description" content={description} />
      <link rel="canonical" href={path} />
      <meta property="og:title" content={finalTitle} />
      <meta property="og:description" content={description} />
      <meta property="og:url" content={path} />
      <meta property="og:type" content="website" />
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={finalTitle} />
      <meta name="twitter:description" content={description} />
    </Helmet>
  );
}
