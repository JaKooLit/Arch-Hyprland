# Guía para Mensajes de Commit

[Ver versión en inglés](./COMMIT_MESSAGE_GUIDELINES.md)

Un buen mensaje de commit debe ser descriptivo y aportar contexto sobre los cambios realizados. Esto facilita entender y revisar los cambios en el futuro.

## Recomendaciones

- Empieza con un resumen breve de los cambios del commit.
- Usa el modo imperativo en el resumen, como si dieras una instrucción. Por ejemplo, "Add feature" en lugar de "Added feature".
- Proporciona detalles adicionales en el cuerpo del mensaje, si es necesario: motivo del cambio, impacto, dependencias añadidas o eliminadas, etc.
- Mantén cada línea en 72 caracteres o menos para que sea fácil de leer en la salida de `git log`.

### Ejemplos de buenos mensajes

- "Add authentication feature for user login"
- "Fix bug causing application to crash on startup"
- "Update documentation for API endpoints"

Recordatorio: escribir mensajes de commit descriptivos ahorra tiempo en el futuro y ayuda a otras personas a entender los cambios hechos al código.

## Tipos de commit

A continuación, una lista (ampliable) de tipos de commit que puedes usar:

`feat`: Añade una característica nueva al proyecto

```markdown
feat: Add multi-image upload support
```

`fix`: Corrige un error o problema en el proyecto

```markdown
fix: Fix bug causing application to crash on startup
```

`docs`: Cambios en documentación

```markdown
docs: Update documentation for API endpoints
```

`style`: Cambios cosméticos o de formato (colores, formateo de código, etc.)

```markdown
style: Update colors and formatting
```

`refactor`: Cambios internos que no alteran el comportamiento, pero mejoran calidad/mantenibilidad

```markdown
refactor: Remove unused code
```

`test`: Añadir o modificar tests

```markdown
test: Add tests for new feature
```

`chore`: Cambios que no encajan en otras categorías (actualizar dependencias, configurar build, etc.)

```markdown
chore: Update dependencies
```

`perf`: Mejoras de rendimiento

```markdown
perf: Improve performance of image processing
```

`security`: Aborda temas de seguridad

```markdown
security: Update dependencies to address security issues
```

`merge`: Fusiones de ramas

```markdown
merge: Merge branch 'feature/branch-name' into develop
```

`revert`: Revertir un commit previo

```markdown
revert: Revert "Add feature"
```

`build`: Cambios en el sistema de build o dependencias

```markdown
build: Update dependencies
```

`ci`: Cambios en la integración continua (CI)

```markdown
ci: Update CI configuration
```

`config`: Cambios en archivos de configuración

```markdown
config: Update configuration files
```

`deploy`: Cambios en el proceso de despliegue

```markdown
deploy: Update deployment scripts
```

`init`: Inicialización de repositorio o proyecto

```markdown
init: Initialize project
```

`move`: Mover archivos o directorios

```markdown
move: Move files to new directory
```

`rename`: Renombrar archivos o directorios

```markdown
rename: Rename files
```

`remove`: Eliminar archivos o directorios

```markdown
remove: Remove files
```

`update`: Actualización de código, dependencias u otros componentes

```markdown
update: Update code
```

Estos son solo ejemplos; puedes definir tipos personalizados si los usas de forma consistente y con mensajes claros y descriptivos.

**Importante:** Si planeas usar un tipo de commit personalizado que no esté en la lista, añádelo aquí para que otras personas lo entiendan también. Crea un pull request para incluirlo en este archivo.
