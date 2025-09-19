workspace "SmartCrops - Verdeva" {

    model {
        // Personas
        rurales = person "Productores Rurales" {
            description "Pequeños y medianos agricultores que dependen de experiencia empírica"
        }

        tecnificados = person "Productores Tecnificados" {
            description "Productores orientados al mercado de exportación con mayor nivel de tecnificación"
        }

        // Grupo para Administración
        adminGroup = group "Administración" {
            admin = person "Administrador" {
                description "Persona que se encarga de dar mantenimiento y actualizaciones a Verdeva"
                tags "admin"
            }
        }

        // Grupo para Sistemas Externos
        externalGroup = group "Sistemas Externos" {
            izipay = softwareSystem "Izipay" {
                description "Pasarela de pagos en línea"
            }

            firebase = softwareSystem "Firebase" {
                description "Servicio de autenticación de usuarios"
            }

            hardware = softwareSystem "Hardware Verdeva" {
                description "Sensores IoT que capturan datos del cultivo"
            }
        }

        // Grupo para Sistema Principal
        mainSystemGroup = group "Sistema Principal" {
            verdeva = softwareSystem "Verdeva" {
                description "Plataforma de Gestión y Monitoreo de Cultivos"

            landingPage = container "Landing Page" {
                description "Página web para promoción de Verdeva"
            }

            mobileApp = container "Mobile App" {
                description "Aplicación móvil para usuarios"
            }

            webApp = container "Web App" {
                description "Aplicación web para usuarios"
            }

            apiApplication = container "API Rest" {
                description "API Rest para comunicación entre apps y la base de datos"
            }

            database = container "Database" {
                description "Base de datos central para almacenar usuarios y cultivos"
            }

            sistemaEmbebido = container "Sistema Embebido" {
                description "Gestión del hardware Verdeva"
            }

            apiEdge = container "API Edge" {
                description "Analiza la información de forma local"
            }

            edgeDatabase = container "Edge Database" {
                description "Base de datos local para almacenar datos procesados por API Edge"
            }

            mainframe = container "Mainframe Verdeva" {
                description "Sistema central que almacena toda la información obtenida"
            }
        }
        }

        // Relaciones a nivel de Contexto (Persona -> Sistema)
        rurales -> verdeva "Gestiona cultivos con"
        tecnificados -> verdeva "Gestiona cultivos con"
        admin -> verdeva "Mantiene y actualiza"

        verdeva -> izipay "Realiza pagos usando"
        verdeva -> firebase "Autentica usuarios"
        verdeva -> hardware "Recibe datos desde sensores"

        // Relaciones a nivel de Contenedor (Contenedor -> Contenedor/Sistema Externo)
        rurales -> webApp "Monitorea y gestiona cultivos usando"
        rurales -> mobileApp "Monitorea y gestiona cultivos usando"
        tecnificados -> webApp "Monitorea y gestiona cultivos usando"
        tecnificados -> mobileApp "Monitorea y gestiona cultivos usando"

        landingPage -> webApp "Redirige a la aplicación web"
        landingPage -> mobileApp "Redirige a la aplicación móvil"

        webApp -> apiApplication "Solicita datos usando"
        mobileApp -> apiApplication "Solicita datos usando"

        apiApplication -> database "Lee y escribe datos"
        apiApplication -> firebase "Valida usuarios"
        apiApplication -> izipay "Procesa pagos"

        sistemaEmbebido -> hardware "Lee datos de sensores"
        sistemaEmbebido -> apiEdge "Envía información capturada"
        
        apiEdge -> edgeDatabase "Lee y escribe datos localmente"
        apiEdge -> apiApplication "Actualiza información central"
        
        apiApplication -> mainframe "Utiliza datos históricos y consolidados"

        // Entornos de deployment
        live = deploymentEnvironment "Live" {
            deploymentNode "Hardware Verdeva" {
                description "Dispositivos en el campo del cliente"
                containerInstance sistemaEmbebido
                containerInstance apiEdge
                containerInstance edgeDatabase
            }

            deploymentNode "Web Browser" {
                description "Dispositivo cliente (navegador)"
                containerInstance landingPage
                containerInstance webApp
            }

            deploymentNode "Mobile Device" {
                description "Dispositivo cliente (móvil)"
                containerInstance mobileApp
            }

            deploymentNode "Cloud - SmartCrops" {
                description "Servidores en la nube"
                containerInstance apiApplication
                containerInstance database
                containerInstance mainframe
            }
        }
    }

    views {
        systemLandscape verdeva_landscape {
            include *
            autolayout lr
            title "System Landscape - SmartCrops"
        }

        systemContext verdeva verdeva_context {
            include *
            autolayout lr
            title "System Context - Verdeva"
        }

        container verdeva verdeva_container {
            include *
            autolayout lr
            title "Container Diagram - Verdeva"
        }

        deployment * "Live" {
            include *
            autolayout lr
            title "Deployment Diagram - Verdeva"
        }

        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            
            # Estilo especial para el administrador
            element "admin" {
                background #ff6b6b
                color #ffffff
                shape person
                stroke #d63384
                strokeWidth 3
            }
            
            # Estilo para las relaciones del administrador
            relationship "admin->*" {
                color #ff6b6b
                thickness 3
                style dashed
            }
            
            # Estilos para los grupos
            element "Group:Administración" {
                background #ffe6e6
                stroke #ff6b6b
                strokeWidth 2
                color #333333
            }
            
            element "Group:Sistemas Externos" {
                background #e6f3ff
                stroke #0066cc
                strokeWidth 2
                color #333333
            }
            
            element "Group:Sistema Principal" {
                background #e6ffe6
                stroke #00cc66
                strokeWidth 2
                color #333333
            }
        }

        theme default
    }
}