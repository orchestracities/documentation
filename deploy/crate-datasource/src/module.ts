import {CrateDatasource} from './datasource';
import {CrateDatasourceQueryCtrl} from './query_ctrl';
import {CrateConfigCtrl} from './config_ctrl';

class CrateQueryOptionsCtrl {
  static templateUrl = 'partials/query.options.html';
}

class CrateAnnotationsQueryCtrl {
  static templateUrl = 'partials/annotations.editor.html';
}

export {
  CrateDatasource as Datasource,
  CrateDatasourceQueryCtrl as QueryCtrl,
  CrateConfigCtrl as ConfigCtrl,
  CrateQueryOptionsCtrl as QueryOptionsCtrl,
  CrateAnnotationsQueryCtrl as AnnotationsQueryCtrl,
};
