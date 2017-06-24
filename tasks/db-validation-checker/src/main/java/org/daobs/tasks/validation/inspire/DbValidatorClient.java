/**
 * Copyright 2014-2016 European Environment Agency
 *
 * Licensed under the EUPL, Version 1.1 or – as soon
 * they will be approved by the European Commission -
 * subsequent versions of the EUPL (the "Licence");
 * You may not use this work except in compliance
 * with the Licence.
 * You may obtain a copy of the Licence at:
 *
 * https://joinup.ec.europa.eu/community/eupl/og_page/eupl
 *
 * Unless required by applicable law or agreed to in
 * writing, software distributed under the Licence is
 * distributed on an "AS IS" basis,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied.
 * See the Licence for the specific language governing
 * permissions and limitations under the Licence.
 */

package org.daobs.tasks.validation.inspire;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.support.JdbcDaoSupport;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.Normalizer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

/**
 * Query a database and retrieve validation results for
 * a metadata record.
 */
public class DbValidatorClient extends JdbcDaoSupport {
  private Log log = LogFactory.getLog(this.getClass());

  /**
   * Valid INSPIRE rule result varchar in database.
   */
  private String validRuleResult;
  /**
   * SQL query to get INSPIRE rule result from a metadata uuid.
   */
  private String selectMetadataValidationResultQuery;
  /**
   * SQL query to get adhérent from a metadata uuid.
   */
  private String selectOwnerQuery;

  public String getSelectOwnerQuery() {
    return selectOwnerQuery;
  }

  public void setSelectOwnerQuery(String selectOwnerQuery) {
    this.selectOwnerQuery = selectOwnerQuery;
  }

  /**
   * Constuctor.
   *
   * @param dataSource                          Database datasource
   * @param validRuleResult                     Valid INSPIRE rule result varchar in database
   * @param selectMetadataValidationResultQuery SQL query to get metadata INSPIRE
   *                                            rule result from a metadata uuid
   */
  public DbValidatorClient(DataSource dataSource,
                           String validRuleResult,
                           String selectMetadataValidationResultQuery,
                           String selectOwnerQuery) {
    setDataSource(dataSource);
    this.validRuleResult = validRuleResult;
    this.selectMetadataValidationResultQuery = selectMetadataValidationResultQuery;
    this.selectOwnerQuery = selectOwnerQuery;
  }

  /**
   * Default constructor.
   */
  public DbValidatorClient() {
  }

  /**
   * Remove accents.
   *
   */
  public static String stripAccents(String text) {
    text = Normalizer.normalize(text, Normalizer.Form.NFD);
    text = text.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
    return text;
  }

  /**
   * validRuleResult getter.
   *
   */
  public String getValidRuleResult() {
    return validRuleResult;
  }

  /**
   * validRuleResult setter.
   */
  public void setValidRuleResult(String validRuleResult) {
    validRuleResult = validRuleResult != null ? stripAccents(validRuleResult.trim()) : null;
    this.validRuleResult = validRuleResult;
  }

  /**
   * selectMetadataValidationResultQuery getter.
   *
   */
  public String getSelectMetadataValidationResultQuery() {
    return selectMetadataValidationResultQuery;
  }

  /**
   * selectMetadataValidationResultQuery setter.
   *
   */
  public void setSelectMetadataValidationResultQuery(
      String selectMetadataValidationResultQuery) {
    this.selectMetadataValidationResultQuery = selectMetadataValidationResultQuery;
  }

  /**
   * Validate a metadata from its uuid.
   *
   * @param metadataUuid metadata uuid
   * @return metadata validation report
   * @throws DataAccessException Datasource exception
   * @throws SQLException        SQL exception
   */
  public ValidationReport validate(String metadataUuid) throws DataAccessException, SQLException {

    //validation report
    ValidationReport report = new ValidationReport(100);

    //query database to get the metadata INSPIRE rule result
    List<String> results = getJdbcTemplate().query(
        selectMetadataValidationResultQuery,
        new String[]{metadataUuid},
        new org.springframework.jdbc.core.RowMapper<String>() {
        @Override
        public String mapRow(ResultSet rs, int rowNum) throws SQLException {
          return rs.getString(1);
        }
      });
    //non referenced INSPIRE metadata in database
    if (results.size() == 0) {
      String resultStr = String.format(
          "Record '%s' not found in database.",
          metadataUuid);
      report.setStatus(false);
      report.setInfo(resultStr);
      report.setReport(resultStr);
      report.setCompletenessIndicator(0);
    } else if (stripAccents(results.get(0).trim()).compareTo(validRuleResult) != 0) {
      //invalid INSPIRE metadata
      //results contains list of inspire non conformities
      String resultStr = getResultsStr(results);
      report.setStatus(false);
      report.setInfo(resultStr);
      report.setReport(resultStr);
      report.setCompletenessIndicator(0);
    } else {
      //valid INSPIRE metadata
      report.setStatus(true);
      report.setInfo(results.get(0));
      report.setReport(results.get(0));
      report.setCompletenessIndicator(100);
    }
    return report;
  }

  public Map<String, Object> getAdherent(String metadataUuid) throws DataAccessException, SQLException {

    Map<String, Object> results = new HashMap<>();
    try {
      results = getJdbcTemplate().queryForMap(
        selectOwnerQuery,
        new String[]{metadataUuid});
    } catch (EmptyResultDataAccessException e) {
      log.debug(String.format("No adherent found for %s.", metadataUuid));
      results = new HashMap<>();
      results.put("nom_adherent", "");
      results.put("nom_pt_moiss", "");
    }
    return results;
  }

  /**
   * Construct a result string from a list of inspire non conformities.
   */
  private String getResultsStr(List<String> results) {
    StringBuilder resultsStr = new StringBuilder();
    if (results != null && results.size() > 0) {
      for (String result : results) {
        resultsStr.append(result);
        resultsStr.append(" ");
      }
    }
    return resultsStr.toString();
  }
}
