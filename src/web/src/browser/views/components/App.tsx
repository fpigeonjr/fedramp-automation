import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import React from 'react';

import { useAppState } from '../hooks';
import { BetaBanner } from './BetaBanner';
import { DevelopersPage } from './DevelopersPage';
import { Footer } from './Footer';
import { Header } from './Header';
import { HomePage } from './HomePage';
import { InnerPageLayout } from './InnerPageLayout';
import { UsaBanner } from './UsaBanner';
import { UsageTrackingPage } from './UsageTrackingPage';
import { ValidatorContentOverlay } from './ValidatorContentOverlay';
import { ValidatorPage } from './ValidatorPage';
import { ViewerPage } from './ViewerPage';

const CurrentPage = () => {
  const { currentRoute } = useAppState().router;
  if (currentRoute.type === 'Home') {
    return (
      <div className="grid-container">
        <HomePage />
      </div>
    );
  } else if (
    currentRoute.type === 'DocumentSummary' ||
    currentRoute.type === 'DocumentPOAM' ||
    currentRoute.type === 'DocumentSAP' ||
    currentRoute.type === 'DocumentSAR' ||
    currentRoute.type === 'DocumentSSP'
  ) {
    return (
      <>
        <InnerPageLayout>
          <ValidatorPage
            documentType={
              {
                DocumentSummary: null,
                DocumentPOAM: 'poam',
                DocumentSAP: 'sap',
                DocumentSAR: 'sar',
                DocumentSSP: 'ssp',
              }[currentRoute.type] as OscalDocumentKey | null
            }
          />
        </InnerPageLayout>
        <ValidatorContentOverlay />
      </>
    );
  } else if (currentRoute.type === 'Assertion') {
    return (
      <InnerPageLayout>
        <ViewerPage assertionId={currentRoute.assertionId} />
      </InnerPageLayout>
    );
  } else if (currentRoute.type === 'Developers') {
    return (
      <InnerPageLayout>
        <DevelopersPage />
      </InnerPageLayout>
    );
  } else if (currentRoute.type === 'UsageTracking') {
    return (
      <InnerPageLayout>
        <UsageTrackingPage />
      </InnerPageLayout>
    );
  } else {
    const _exhaustiveCheck: never = currentRoute;
    return <></>;
  }
};

export const App = () => {
  return (
    <div>
      <BetaBanner />
      <UsaBanner />
      <Header />
      <CurrentPage />
      <Footer />
    </div>
  );
};
