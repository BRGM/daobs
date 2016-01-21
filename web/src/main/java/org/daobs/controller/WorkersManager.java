package org.daobs.controller;

import org.apache.camel.CamelContext;
import org.apache.camel.spi.InflightRepository;
import org.daobs.workers.ContextStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Draft camel workers prototype.
 *
 * Another option could be to use JMX and
 * Jolokia REST API ?
 * https://jolokia.org/reference/html/index.html
 *
 * Created by francois on 20/01/16.
 */
@Controller
public class WorkersManager {

    @Autowired
    ContextStore camelContextStore;

    @RequestMapping(value = "/workers",
            produces = {
                    MediaType.APPLICATION_XML_VALUE,
                    MediaType.APPLICATION_JSON_VALUE,
                    MediaType.APPLICATION_XHTML_XML_VALUE
            },
            method = RequestMethod.GET)
    @ResponseBody
    public List<String> getDashboards() {
        ArrayList<String> result = new ArrayList<>();

        for(CamelContext context : camelContextStore.getCamelContexts()) {
            Collection<InflightRepository.InflightExchange> inFlightExchanges =
                    context.getInflightRepository().browse();

            for (InflightRepository.InflightExchange e : inFlightExchanges) {
                // TODO:
                // * Use Unit Of Work
                // * testing
                //            inFlightExchanges.remove(e);
                //            e.getExchange().setProperty(Exchange.ROUTE_STOP, Boolean.TRUE);
                // http://camel.apache.org/uuidgenerator.html could be customized
                // to have workers id set by starter app.
                result.add(String.format("[%s:%s] %s (%dms/%dms) - step %s - Nb of records: %s",
                        e.getExchange().getUnitOfWork().getOriginalInMessage().getHeader("harvesterUuid"),
                        e.getExchange().getUnitOfWork().getOriginalInMessage().getHeader("harvesterTerritory"),
                        e.getExchange().getExchangeId(),
                        e.getElapsed(),
                        e.getDuration(),
                        e.getExchange().getFromRouteId(),
                        e.getExchange().getUnitOfWork().getOriginalInMessage().getHeader("numberOfRecordsMatched")
                ));
            }
        }
        return result;
    }
}
