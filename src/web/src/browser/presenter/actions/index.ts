export * as schematron from './schematron';
export * as validator from './validator';

import { useEffects } from '@asap/browser/views/hooks';
import type { PresenterConfig } from '..';
import * as router from '../router';

export const onInitializeOvermind = ({
  actions,
  effects,
  state,
}: PresenterConfig) => {
  actions.setCurrentRoute(window.location.hash);
  effects.location.listen((url: string) => {
    actions.setCurrentRoute(url);
  });
  window.addEventListener('hashchange', event => {
    const url = event.newURL.split('#')[1];
    actions.setCurrentRoute(url);
  });
  effects.useCases
    .getSSPSchematronAssertions()
    .then(schema => (state.schematron.schematronAsserts = schema));
};

export const setCurrentRoute = (
  { effects, state }: PresenterConfig,
  url: string,
) => {
  const route = router.getRoute(url);
  if (route.type !== 'NotFound') {
    state.currentRoute = route;
  }
  effects.location.replace(router.getUrl(state.currentRoute));
};

export const getAssetUrl = ({ state }: PresenterConfig, assetPath: string) => {
  return `${state.baseUrl}/${assetPath}`;
};
