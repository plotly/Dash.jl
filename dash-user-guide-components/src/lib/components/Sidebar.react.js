import React, {Component} from 'react';
import PropTypes from 'prop-types';
import {
    all,
    assocPath,
    concat,
    contains,
    filter,
    find,
    has,
    hasPath,
    path,
    pathOr,
    propOr,
    slice,
    without
} from 'ramda';
import { History } from '@plotly/dash-component-plugins';
import Link from 'dash-core-components/lib/components/Link.react.js';

/*
 * event polyfill for IE
 * https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/CustomEvent
 */
function CustomEvent(event, params) {
    // eslint-disable-next-line no-param-reassign
    params = params || {
        bubbles: false,
        cancelable: false,
        // eslint-disable-next-line no-undefined
        detail: undefined,
    };
    const evt = document.createEvent('CustomEvent');
    evt.initCustomEvent(
        event,
        params.bubbles,
        params.cancelable,
        params.detail
    );
    return evt;
}
CustomEvent.prototype = window.Event.prototype;

function traverse(obj, pathArray, func) {
    if (obj.chapters) {
        for(let i=0; i < obj.chapters.length; i++) {
            traverse(obj.chapters[i], pathArray.concat(['chapters', i]), func);
        }
    }
    func(obj, pathArray);
}

function searchChapter(chapter, searchWord) {
    return (searchWord) => {
        if(chapter.hide_in_sidebar) {
            return false;
        }
        const terms = [
            'name', 'description', 'description_short',
            'url', 'meta_keywords'
        ];
        for(let i=0; i<terms.length; i++) {
            if(contains(searchWord.toLowerCase(), propOr('', terms[i], chapter).toLowerCase())) {
                return true;
            }
        }
        return false;
    }
}

function filterUrls (urls, search) {
    const matches = [];
    traverse({'chapters': urls}, [], function(o, pathArray) {
        let matched = true;
        const searchWords = without('', search.split(' '));

        if (all(searchChapter(o), searchWords)) {
            matches.push(pathArray);
        }

    })

    if(matches.length > 0) {
        let newObj = {};
        let searchResults = [];
        matches.forEach(matchPath => {
            const searchResult = {
                'names': []
            };
            for(let i=0; i<matchPath.length + 1; i++) {
                const namePath = concat(slice(0, i, matchPath), ['name']);
                if(hasPath(namePath, {'chapters': urls})) {
                    searchResult.names.push(path(namePath, {'chapters': urls}));
                }
            }
            searchResult.url = path(concat(matchPath, ['url']), {'chapters': urls});
            searchResult.description = path(concat(matchPath, ['description']), {'chapters': urls});
            searchResult.description_short = path(concat(matchPath, ['description_short']), {'chapters': urls});
            newObj = assocPath(matchPath, path(matchPath, {'chapters': urls}), newObj)
            searchResults.push(searchResult);
        });
        return {
            chapters: newObj.chapters,
            searchResults
        };
    }
    return {}
}

export default class Sidebar extends Component {
    constructor(props) {
        super(props);
        this.state = {search: ''};
        this.onLocationChanged = this.onLocationChanged.bind(this);
    }

    onLocationChanged() {
        this.forceUpdate();
    }

    componentDidMount() {
        this._clearOnLocationChanged = History.onChange(this.onLocationChanged);
    }

    componentWillUnmount() {
        this._clearOnLocationChanged();
    }


    render() {
        const {children, depth, urls} = this.props;
        let searchResults = [];
        if(this.state.search.length > 2) {
            searchResults = filterUrls(
                JSON.parse(JSON.stringify(urls)),
                this.state.search
            ).searchResults;
        }

        function handleKeyUp(event) {
            if (event.keyCode === 13) {
                if(searchResults.length > 0) {
                    window.history.pushState({}, '', searchResults[0].url);
                    window.dispatchEvent(new CustomEvent('_dashprivate_pushstate'));
                }
            }
        }

        return (
            <div className="sidebar">
                <input
                    autoFocus
                    tabIndex="1"
                    type="search"
                    autocomplete="false"
                    value={this.state.search}
                    onChange={e => this.setState({search: e.target.value})}
                    onKeyUp={handleKeyUp}
                    id="sidebar-search-input"
                    placeholder={'Filter...'}
                />
                {
                    this.state.search.length > 2 ?
                    <SearchResults
                        search={this.state.search}
                        searchResults={searchResults}
                        children={children}
                    />
                    :
                    <TreeSidebar
                        urls={urls}
                        depth={depth}
                        force_closed={
                            (window.location.pathname === '/' ||
                             window.location.pathname === '/Docs' ||
                             window.location.pathname === '/Docs/') &&
                            this.state.search === ''
                        }
                    />
                }
            </div>
        );
    }
}

class SearchResults extends Component {
    render() {
        const {children, searchResults, search} = this.props;
        if (!searchResults || searchResults.length == 0) {
            return (
                <div className='no-results'>
                    <span>{'No results found.'}</span>

                    {children}

                    <span>{'Try the same search on '}</span>
                    <a href={`https://google.com/search?q=site%3Adash.plotly.com+${search}`}>
                        Google
                    </a>
                    <span>{', '}</span>
                    <a href={`https://duckduckgo.com?q=site%3Adash.plotly.com+${search}`}>
                        Duck Duck Go
                    </a>
                    <span>{', or the '}</span>
                    <a href={`https://community.plotly.com/search?q=${search}%20category%3A16`}>
                        Dash Community Forum
                    </a>
                    <span>{'. '}</span>

                    <hr/>

                    <small>
                        {`No luck? Here is a more specific search by wrapping your
                        query in "quotes" on `}
                        <a href={`https://google.com/search?q=site%3Adash.plotly.com+"${search}"`}>
                            Google
                        </a>
                        <span>{', '}</span>
                        <a href={`https://duckduckgo.com?q=site%3Adash.plotly.com+"${search}"`}>
                            Duck Duck Go
                        </a>
                        <span>{', or the '}</span>
                        <a href={`https://community.plotly.com/search?q="${search}"%20category%3A16`}>
                            Dash Community Forum
                        </a>
                        <span>{'. '}</span>
                    </small>

                    <hr/>

                    {
                        children ? (
                            <small>
                                <i>
                                    {`Still no luck? Get help for what you are
                                      looking for by opening a topic on the `}
                                    <a href="https://community.plotly.com/c/dash">Dash Community Forum</a>
                                    {'.'}
                                </i>
                            </small>
                        ) : null
                    }

                </div>
            )
        }

        const resultItems = [];
        for(let i=0; i<searchResults.length; i++) {
            // Only display the last two names
            searchResults[i].name = searchResults[i].names.slice(
                searchResults[i].names.length - 2,
                searchResults[i].names.length
            ).join(' > ');
            resultItems.push(link(searchResults[i]));
        }

        return (
            <div className='search-results'>
                {resultItems}
            </div>
        );
    }
}

function link(chapter) {
    if(!chapter.url) {
        return null;
    }
    let title = null;
    if (chapter.description_short) {
        title = chapter.description_short.trim();
    } else if (chapter.description) {
        title = chapter.description.trim();
    }
    const active = window.location.pathname.replace(/\/$/, "") == chapter.url.replace(/\/$/, "");

    const linkProps = {
        href: chapter.url,
        title: title,
        className: `${active ? 'active': ''}`,
        children: chapter.name
    };
    if (chapter.url.indexOf('http') === 0) {
        return <a {...linkProps}/>;
    }
    return <Link {...linkProps}/>;
}

class TreeSidebar extends Component {
    render() {
        const {force_closed, depth, urls} = this.props;
        const chapter_elements = [];

        for(let i=0; i<urls.length; i++) {

            const chapter = urls[i];
            if(!chapter) {
                continue;
            } else if (chapter.chapters && chapter.hide_chapters_in_sidebar) {
                chapter_elements.push(link(chapter));
            } else if (chapter.chapters) {

                const open = (
                    !force_closed
                    &&
                    (
                        (
                            has('urls', chapter)
                            &&
                            Boolean(find(url =>
                                 url.indexOf(window.location.pathname) === 0
                            ), chapter.urls)
                        )
                        ||
                        Boolean(find(

                            subchapter => {
                                return (
                                    propOr('', 'url', subchapter)
                                    .indexOf(window.location.pathname) === 0
                                );
                            },

                            chapter.chapters
                        ))
                    )
                );
                chapter_elements.push(
                    <details open={open}>
                        <summary>{chapter.name}</summary>
                        <TreeSidebar
                            urls={chapter.chapters}
                            depth={depth+1}
                            force_closed={force_closed}
                        />
                    </details>
                );

            } else {
                chapter_elements.push(link(chapter));

            }
        }

        return (
            <div className={`sidebar--${depth}`}>
                {chapter_elements}
            </div>
        )
    }
}

Sidebar.defaultProps = {
    depth: 0
};

Sidebar.propTypes = {
    /**
     * The ID used to identify this component in Dash callbacks.
     */
    id: PropTypes.string,

    /**
     * Custom content in the "no results found" panel
     */
    children: PropTypes.node,

    /**
     * URLs
     */
    urls: PropTypes.array,

    /**
     * depth
     */
    depth: PropTypes.number,

    /**
     * Dash-assigned callback that should be called to report property changes
     * to Dash, to make them available for callbacks.
     */
    setProps: PropTypes.func
};
