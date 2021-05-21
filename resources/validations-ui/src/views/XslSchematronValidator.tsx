import React, { ChangeEvent, useState } from 'react';

import { transform } from '../adapters/saxon-js';

interface Props {}

function XslSchematronValidator({}: Props) {
  const [svrl, setSvrl] = useState<string | true>('');

  const setXmlDocument = (event: ChangeEvent<HTMLInputElement>) => {
    if (event.target.files?.length) {
      const inputFile = event.target.files[0];
      const reader = new FileReader();
      reader.addEventListener('load', event => {
        const sourceText = event.target?.result?.toString();
        if (sourceText) {
          setSvrl(true);
          transform({ sourceText }).then(setSvrl);
        }
      });
      reader.readAsText(inputFile);
    }
  };

  return (
    <div className="usa-form-group">
      <label className="usa-label" htmlFor="file-input-specific">
        Upload a FedRAMP OSCAL SSP document
      </label>
      <span className="usa-hint" id="file-input-specific-hint">
        Select XML file
      </span>
      <input
        id="file-input-specific"
        className="usa-file-input"
        type="file"
        name="file-input-specific"
        aria-describedby="file-input-specific-hint"
        accept=".xml"
        onChange={setXmlDocument}
      />
      {svrl === true ? <div className="loader" /> : <code>{svrl}</code>}
    </div>
  );
}

export default XslSchematronValidator;
