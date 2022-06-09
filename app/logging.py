class Log:
    def print(script_name, func_name, *args):
        out = '[{script}.{func}]: {out}'.format(
            script = script_name,
            func = func_name,
            out = ' '.join([str(arg) for arg in args])
        )
        print(out)
