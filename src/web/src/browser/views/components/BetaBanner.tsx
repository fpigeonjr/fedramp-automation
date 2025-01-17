import classnames from 'classnames';
import React from 'react';

import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import { useActions, useAppState } from '../hooks';

export const BetaBanner = () => {
  const actions = useActions();
  const { metrics } = useAppState();

  return (
    <section className="beta-banner">
      <div className="grid-container">
        <div className="grid-col-auto">
          <span className="usa-accordion">
            <strong>BETA SITE:</strong> We are testing a new validation
            automation system for FedRAMP audit reviews.
            <button
              className="usa-accordion__button usa-banner__button"
              aria-expanded="false"
              aria-controls="usage-tracking-disclosure"
            >
              <span className="usa-banner__button-text">
                {metrics.matches('OPT_IN')
                  ? 'We are collecting your usage data.'
                  : 'We are NOT collecting your usage data.'}
              </span>
            </button>
            <div id="usage-tracking-disclosure">
              <div role="region" aria-label="Usage tracking on 10x ASAP">
                <div className="usa-banner__message">
                  <div className="grid-row">
                    <h2 className="text-bold margin-bottom-0">
                      <svg
                        className={classnames('usa-icon', {
                          'text-blue': metrics.matches('OPT_IN'),
                          'text-red': metrics.matches('OPT_OUT'),
                        })}
                        style={{ verticalAlign: 'middle' }}
                        aria-hidden="true"
                        focusable="false"
                        role="img"
                      >
                        <use
                          xlinkHref={actions.getAssetUrl(
                            metrics.matches('OPT_IN')
                              ? 'uswds/img/sprite.svg#visibility'
                              : 'uswds/img/sprite.svg#visibility_off',
                          )}
                        ></use>
                      </svg>
                      {'  '}Usage tracking on 10x ASAP
                    </h2>
                  </div>
                  <div className="grid-row">
                    <div>
                      <p>
                        The 10x ASAP team wants to understand your needs. If you
                        would like to help, please opt-in to sharing anonymized
                        usage information.
                      </p>
                      <p>
                        We do not collect usage data without your consent.{' '}
                        {metrics.matches('OPT_IN') ? (
                          <strong>
                            We are currently collecting usage data.
                          </strong>
                        ) : (
                          <strong>
                            We are NOT currently collecting usage data.
                          </strong>
                        )}
                      </p>
                    </div>
                  </div>
                </div>

                <ul className="usa-button-group">
                  <li className="usa-button-group__item">
                    <button
                      value="accept"
                      type="button"
                      name="usage-tracking"
                      className="usa-button"
                      onClick={() => actions.metrics.setOptInStatusOn()}
                    >
                      Accept usage tracking
                    </button>
                  </li>
                  <li className="usa-button-group__item">
                    <button
                      value="reject"
                      type="button"
                      name="usage-tracking"
                      className="usa-button usa-button--outline"
                      onClick={() => actions.metrics.setOptInStatusOff()}
                    >
                      Reject usage tracking
                    </button>
                  </li>
                </ul>
                <a href={getUrl(Routes.usageTracking)}>
                  What usage data we collect
                </a>
              </div>
            </div>
          </span>
        </div>
      </div>
    </section>
  );
};
