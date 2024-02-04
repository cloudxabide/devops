case $(echo $TERM_PROGRAM) in
  'iTerm.app')
    echo "Check out my bash"
    exec /bin/bash
  ;;
  'Apple_Terminal')
    echo "Embrace the Dark Side"
  ;;
esac
