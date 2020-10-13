import React, {Component} from 'react';
import PropTypes from 'prop-types';
import {replace} from 'ramda';
import { History } from '@plotly/dash-component-plugins';


class PageMenu extends Component {
    constructor(props) {
        super(props);
        this.renderLinksInDom = this.renderLinksInDom.bind(this);
    }

    componentDidUpdate() {
        this.renderLinksInDom();
    }

    componentDidMount() {
        this.renderLinksInDom();
    }

    renderLinksInDom() {
        let timer;
        function renderLinksInDomInner() {
            const parent = document.getElementById('page-menu--links');
            const elements = document.querySelectorAll('h1, h2, h3, h4, h5, h6');
            if(elements.length === 0) {
                /*
                 * Sometimes the page content isn't rendered on page load
                 * even though this component is updated by a callback that
                 * listens to the output of the content
                 */
                timer = window.setTimeout(renderLinksInDomInner, 250);
                return;
            }
            window.clearTimeout(timer);
            const ignoreElementsNodeList = document.querySelectorAll(`
                .example-container h1,
                .example-container h2,
                .example-container h3,
                .example-container h4,
                .example-container h5,
                .example-container h6
            `);
            const ignoreElementsArray = [];
            for(let i=0; i<ignoreElementsNodeList.length; i++) {
                ignoreElementsArray[i] = ignoreElementsNodeList[i];
            }

            const links = [];
            for(let i=0; i<elements.length; i++) {
                const el = elements[i];
                if(ignoreElementsArray.indexOf(el) > -1) {
                    continue;
                }
                if (!el.id) {
                    let id = replace(/ /g, '-', el.innerText).toLowerCase();
                    // Remove ' since we use quotes below in `onClick=pageMenuScroll('`
                    id = replace(/'/g, '', id);
                    // Remove " just to be safe
                    id = replace(/"/g, '', id);
                    el.id = id;
                }
                /*
                 * TODO - Replace with a proper a and remove pageMenuScroll
                 * once https://github.com/plotly/dash-core-components/issues/769
                 * is fixed
                 */
                links.push(`
                    <div class="page-menu--link-parent">
                        <span
                            id="page-menu--link-${i}"
                            class="page-menu--link"
                            onClick="pageMenuScroll('${el.id}')"
                        >
                            ${replace(
                                /</g, '&lt;',
                                replace(/>/g, '&gt;', el.innerText)
                            )}
                        </span>
                    </div>
                `);
            };
            parent.innerHTML = links.join('');
        }
        timer = setTimeout(renderLinksInDomInner, 0);
    }

    render() {
        const {id, loading_state} = this.props;
        let pathnameClassName = replace(/\//g, '', window.location.pathname);
        if (pathnameClassName === '') {
            pathnameClassName = 'home';
        }
        return (
            <div
                data-dash-is-loading={
                    (loading_state && loading_state.is_loading) || undefined
                }
                id={id}
                className={`page-menu ${pathnameClassName}`}
            >
                <div className='page-menu--header'>{'On This Page'}</div>
                <div id="page-menu--links"/>
            </div>
        )
    }
}

PageMenu.propTypes = {
    /**
     * The ID used to identify this component in Dash callbacks.
     */
    id: PropTypes.string,

    /*
     * dummy props to force updates
     */
    dummy: PropTypes.string,
    dummy2: PropTypes.string,

    /**
     * Object that holds the loading state object coming from dash-renderer
     */
    loading_state: PropTypes.shape({
        /**
         * Determines if the component is loading or not
         */
        is_loading: PropTypes.bool,
        /**
         * Holds which property is loading
         */
        prop_name: PropTypes.string,
        /**
         * Holds the name of the component that is loading
         */
        component_name: PropTypes.string,
    }),

    /**
     * Dash-assigned callback that should be called to report property changes
     * to Dash, to make them available for callbacks.
     */
    setProps: PropTypes.func
};

export default PageMenu;
