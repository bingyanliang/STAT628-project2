## from shiny import App, reactive, render, ui
## 
## app_ui = ui.page_fluid(
##     ui.input_slider("x1", "Height", 1, 100, 50),
##     ui.input_slider("x2", "Abdomen", 1, 200, 100),
##     ui.input_slider("x3", "Wrist", 1, 30, 15),
##     ui.output_text_verbatim("txt1"),
## )
## 
## 
## def server(input, output, session):
##     # Each time input.x() changes, it invalidates this reactive.Calc object. If someone
##     # then calls x_times_2(), it will execute the user function and return the value.
##     # The value is cached, so if another function calls x_times_2(), it will simply
##     # return the cached value, without re-running the function.  When input.x() changes
##     # again, it will invalidate this reactive.Calc, and the cache will be cleared.
##     @reactive.Calc
##     def linear_regression():
##         val = -0.3975912*input.x1() + 0.7261291 * input.x2() + -1.5636103 * input.x3()
##         print(f"Running x_times_2(). Result is {val}.")
##         return val
## 
##     @output
##     @render.text
##     def txt1():
##         return f'predicted bodyfat is: "{linear_regression()}"'
## 
## app = App(app_ui, server)

from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

@app.route("/", methods=['GET', 'POST'])
@app.route("/", methods=['GET', 'POST'])
def index():
    result = None  # Ensure `result` is defined
    error_message = None  # Ensure `error_message` is defined
    
    if request.method == 'POST':
        try:
            # Attempt to retrieve and convert form data
            height = float(request.form.get('height'))
            abdomen = float(request.form.get('abdomen'))
            wrist = float(request.form.get('wrist'))
            
            # Perform calculation if all retrievals were successful
            result = -0.3975912*height + 0.7261291*abdomen + -1.5636103*wrist
        except (TypeError, ValueError):
            # Handle case where conversion to float fails
            error_message = "Please ensure all fields are numeric and non-empty."
    
    # Render template with result and/or error message
    return render_template("index.html", result=result, error_message=error_message)

if __name__ == "__main__":
    app.run(debug=True)