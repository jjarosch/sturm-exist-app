<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="xs tei exslt" version="2.0">

<!--
(:
 : DER STURM
 : A Digital Edition of Sources from the International Avantgarde
 :
 : Edited and developed by Marjam Trautmann and Torsten Schrade
 : Academy of Sciences and Literature | Mainz
 :
 : Contains the toolbar with the pagination and xml/metadata links for the 
 : letter detail view.
 :
 : @author Torsten Schrade
 : @email <Torsten.Schrade@adwmainz.de>
 : @licence MIT
:)
-->

    <xsl:param name="first"/>
    <xsl:param name="previous"/>
    <xsl:param name="next"/>
    <xsl:param name="last"/>
    <xsl:param name="metadata"/>
    <xsl:param name="kalliopeuri"/>

    <xsl:template name="toolbar">
        <section class="twelve columns toolbar">
            <ul class="pagination">
                <li class="first">
                    <a class="black button" href="{$first}#main" title="An den Anfang">|←</a>
                </li>
                <li class="previous">
                    <a class="black button" href="{$previous}#main" title="Vorheriger Brief">←</a>
                </li>
                <li class="next">
                    <a class="black button" href="{$next}#main" title="Nächster Brief">→</a>
                </li>
                <li class="last">
                    <a class="black button" href="{$last}#main" title="An das Ende">→|</a>
                </li>
            </ul>
            <ul class="actions">
                <li class="xml">
                    <a target="_blank" class="black button" href="{concat('https://sturm-edition.de/api/files/', //tei:publicationStmt/tei:idno[@type = 'file'])}" title="XML Quelle ansehen">➚ XML</a>
                </li>
                <li class="metadata">
                    <a target="_blank" class="black button" href="{$kalliopeuri}" title="Findbucheintrag im Kalliope-Verbundkatalog">➚ Metadaten</a>
                </li>
            </ul>
        </section>
    </xsl:template>
</xsl:stylesheet>