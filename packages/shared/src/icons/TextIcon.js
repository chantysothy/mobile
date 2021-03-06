// @flow

import * as React from 'react';
import { Translation } from '@kiwicom/mobile-localization';
import type { StylePropType } from '@kiwicom/mobile-shared';

import Color from '../Color';
import Text from '../Text';
import StyleSheet from '../PlatformStyleSheet';

type Props = {|
  +code: string,
  style?: StylePropType,
|};

const styleSheet = StyleSheet.create({
  icon: {
    fontFamily: 'spfont', // font with all the icons (see Fontastic)
    includeFontPadding: false,
    textAlignVertical: 'center',
  },
});

/**
 * These icons are font mobile icons from Fontastic. Usage:
 *
 * ```js
 * <TextIcon code="&#xe0a3;" />
 * ```
 *
 * We currently support only one font family: "spfont".
 */
class TextIcon extends React.Component<Props> {
  static defaultProps = {
    style: {
      color: Color.textLight,
      fontSize: 20,
    },
  };
  render() {
    return (
      <Text style={[styleSheet.icon, this.props.style]}>
        <Translation passThrough={this.props.code} />
      </Text>
    );
  }
}

export default TextIcon;
