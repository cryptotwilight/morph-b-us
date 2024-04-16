import React from 'react';
import ReactDOM from 'react-dom';
import App from './components/App';
import { AppContainer } from 'react-hot-loader';
import { MetaMaskUIProvider } from "@metamask/sdk-react-ui";

const render = (Component) => {
    ReactDOM.render(
        <MetaMaskUIProvider
            sdkOptions={{
                dappMetadata: {
                    name: "Morph Be Us",
                    url: window.location.href,
                    base64Icon : "AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAArQorFOUhhV3hKqWr4TC63eIywe/jMcDs4i6zzuEnm5PQH31JoBxzMEQvtd5ZHnOP0xxth9ETSlwtAAAADQAAAMMTSUz/L7fV/zLC8v8yw/L0MLrm8i6y3v8xv+3/MsLu/yqmrv8ffUnrI4p2pBVQZNodco3sHG6JMwAAAA0IHybDKZ7F/zLC7/8vttO/M8f3PQwuOZsJISn8E0hZ7ieZvv8yxPT/KJ+b/yaVifYZY3b6EUNT6gccIzMAAAANGmN8wzLA8P8rqLL/H31IjgAAAAsAAADEAAAA2AAAAJcKJzD/La/a/zC52v8kkHf/HG1v/xA/T+oEDxMzAAAADSeXu8MywvD/JI92/x12M4wAAAAzAAAA8gAAAJ4AAABBAQQF8iKDo/8yw/D/I41s/xFFH/8AAADqAAAAMxZUaA0usdzDMb/o/yGGYP8ddzWLAAAAcQAAAP4AAABdAAAADwAAAMsaZ4D/M8X1/yWVgP8PPRv/AAAA6gAAADMlkbQNMLzqwzG95P8hhFn/G24xlwAAALUAAADmAAAAJgEFAgAAAACNGF9z/zPF9f8mlYj5CCIO+QAAAOoAAAAzKZ/GDTG+7MMwvOP/IYNY/xtuMtUQQR/uEUQg5BxxNooddzmHGGIrwCOMh/8yxPP/KZ+srQEDAM4AAADtAAAAMymfxg0xvuzDMLzj/yGDWP8ddTb/HXc4/x13Of8ddjj/HXY4/x12Nf8nmo7/MsP0/y2w23sAAADBAAAA7QAAADMpn8YNMb7swzC84/8hhFn/FVQm/wstFu4XXi11HXg5XB12OGQcdDOLKJ6Y5DLD8/8tsNl8AAAAwgAAAO0AAAAzKZ/GDTG+7MMwvOP/IYVZ/xBAHf8AAADAAAAADAAAAAAddjgAUP//ADC74YIywvD/KaGypAAAAMcAAADtAAAAMymfxg0xvuzDMLzj/yGFWf8QQR3/AAAAgAAAAAAAAAAAAAAAADLC8QAywvF2MsLx/yaYltYCBwDVAAAA7AAAADMpn8YNMb7swzC84/8hhVn/EUQf8wAAAEAAAAAAAAAAABU/KQAywvEAMsLxdzLD8v8ji4rnAQYA4gAAAOwAAAAzKZ/GDTG+7MMwvOP/IYRY/xRTJdILLhYiIIA9Dh12OA8ddjgTG28mKiupta8zxPP/Gmdz/QAAAP0AAADqAAAAMymfxg0xvuzDMLzj/yGDWP8ccTTwHXU4zR12OMwddjjMHXY40h11NegnmY7+M8X1/xZVav8AAAD/AAAA6gAAADMpn8YNMb7swzC84/8hg1j/HXU2/x12OP8ddjj/HXY4/x12OP4ddTXqKJ6Z4jPE9f8WVWr/AAAA/wAAAOoAAAAzAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAHAAAADwAAAA8AAAAAAAAAAAAAAAAAAAA==",
                },
            }}
        >
            <AppContainer>
                <Component/>
            </AppContainer>
        </MetaMaskUIProvider>,
        document.getElementById('react-app-root')
    );
};

render(App);

if(module.hot) {
    module.hot.accept('./components/App', () => {
        render(App)
    });
}

