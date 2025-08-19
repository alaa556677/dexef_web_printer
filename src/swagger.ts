import swaggerJsdoc from 'swagger-jsdoc';

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'WebPrint Agent API',
      version: '1.0.0',
      description: 'Cross-platform Local Print Agent for silent PDF printing',
      contact: {
        name: 'WebPrint Agent',
      },
    },
    servers: [
      {
        url: 'http://127.0.0.1:5123',
        description: 'Development server',
      },
      {
        url: 'http://localhost:5123',
        description: 'Local development server',
      },
    ],
    components: {},
  },
  apis: ['./src/routes/*.ts', './dist/routes/*.js'], // Path to the API routes (source and compiled)
};

export const specs = swaggerJsdoc(options);
