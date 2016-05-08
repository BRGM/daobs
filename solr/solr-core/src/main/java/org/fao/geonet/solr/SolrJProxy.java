/*
 * Copyright (C) 2001-2016 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */

package org.fao.geonet.solr;

import org.apache.solr.client.solrj.SolrClient;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Create a bean providing a connection to the Solr.
 */
@Component
public class SolrJProxy implements InitializingBean {

  private static SolrJProxy instance;
  private SolrClient client;

  @Autowired
  private SolrConfig config;

  private boolean connectionChecked = false;

  /**
   * The first time this method is called, ping the client to check connection status.
   *
   * @return The Solr instance.
   */
  public SolrClient getServer() throws Exception {
    if (!connectionChecked) {
      this.ping();
      connectionChecked = true;
    }
    return client;
  }

  public SolrJProxy setServer(SolrClient server) {
    this.client = server;
    return this;
  }

  /**
   * Connect to the Solr, ping the client to check connection and set the instance.
   */
  @Override
  public void afterPropertiesSet() throws Exception {
    client = config.createClient();
    instance = this;
  }

  /**
   * Ping the Solr.
   */
  public void ping() throws Exception {
    try {
      client.ping();
    } catch (Exception e1) {
      throw new Exception(
        String.format("Failed to ping Solr at URL %s. "
          + "Check configuration.",
          config.getSolrServerUrl()),
        e1);
    }
  }

  public static SolrJProxy get() {
    return instance;
  }
}
